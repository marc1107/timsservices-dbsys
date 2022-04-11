import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class JdbcClient
{
	public static void main(String args[]) throws NumberFormatException, IOException, ParseException
	{

		String name = null;
		String passwd = null;
		BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
		Connection conn = null;
		Statement stmt = null;
		ResultSet rset = null;

		try
		{
			System.out.println("Benutzername: ");
			name = in.readLine();
			System.out.println("Passwort:");
			passwd = in.readLine();
		} catch (IOException e)
		{
			System.out.println("Fehler beim Lesen der Eingabe: " + e);
			System.exit(-1);
		}

		System.out.println("");

		try
		{
			DriverManager.registerDriver(new oracle.jdbc.OracleDriver()); // Treiber laden
			String url = "jdbc:oracle:thin:@oracle12c.in.htwg-konstanz.de:1521:ora12c"; // String für DB-Connection
			conn = DriverManager.getConnection(url, name, passwd); // Verbindung erstellen

			conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE); // Transaction Isolations-Level setzen
			conn.setAutoCommit(false); // Kein automatisches Commit

			stmt = conn.createStatement(); // Statement-Objekt erzeugen

			String query = "";
			int selection = 0;
			while (true)
			{
				do
				{
					selection = GetMenuSelection(in);
				} while (selection != 1 && selection != 2 && selection != 3);

				if (selection == 1)
				{
					query = SucheNachFerienwohnung(in);
					rset = stmt.executeQuery(query);
					System.out.println("ID\t\tFerienWohnung\t\tDurch. Bewertung");
					while (rset.next())
					{
						System.out.print(rset.getString(1) + "\t" + rset.getString(2) + "\t");

						String bewertung = rset.getString(3);
						if (bewertung == null)
							System.out.println("Keine Bewertung");
						else
							System.out.println(bewertung);
					}
				}
				else if (selection == 2)
				{
					query = BuchenVonFerienwohnung(in, stmt);
					stmt.executeUpdate(query);
					conn.commit();
				}
				else
					break;
			}

			stmt.close(); // Verbindung trennen
			conn.commit();
			conn.close();
		} catch (SQLException se)
		{ // SQL-Fehler abfangen
			System.out.println();
			System.out.println("SQL Exception occurred while establishing connection to DBS: " + se.getMessage());
			System.out.println("- SQL state  : " + se.getSQLState());
			System.out.println("- Message    : " + se.getMessage());
			System.out.println("- Vendor code: " + se.getErrorCode());
			System.out.println();
			System.out.println("EXITING WITH FAILURE ... !!!");
			System.out.println();
			try
			{
				conn.rollback(); // Rollback durchführen
			} catch (SQLException e)
			{
				e.printStackTrace();
			}
			System.exit(-1);
		}
	}

	private static int GetMenuSelection(BufferedReader in) throws NumberFormatException, IOException
	{
		System.out.println("\n\n");
		System.out.println("1. Suche nach Ferienwohnung");
		System.out.println("2. Buchen von Ferienwohnung");
		System.out.println("3. Exit");
		System.out.println("Auswahl 1, 2 oder 3:");
		return Integer.parseInt(in.readLine());
	}

	private static String SucheNachFerienwohnung(BufferedReader in) throws IOException
	{
		System.out.println("Land");
		String land = in.readLine();
		System.out.println("Anreisedatum(11/11/2019):");
		String anreisedatum = in.readLine();
		System.out.println("Abreisedatum(11/11/2019):");
		String abreisedatum = in.readLine();
		System.out.println("Sonderausstattungen:");
		String ausstattungen = in.readLine();

		String query = "SELECT f.fwid, f.FwName, AVG(b.AnzSterne) AS \"durchschnittliche Bewertung\" "
				+ "FROM Buchung b " + "RIGHT OUTER JOIN Ferienwhng f ON b.Fwid = f.Fwid "
				+ "INNER JOIN Adresse a ON f.AdrID = a.AdrID " + "WHERE a.Landname = '" + land + "' AND f.Fwid NOT IN "
				+ "(" + "	 SELECT f.Fwid " + "    FROM Buchung b " + "    WHERE b.Anrdatum BETWEEN TO_DATE('"
				+ anreisedatum + "', 'DD/MM/YYYY')  AND  TO_DATE('" + abreisedatum + "', 'DD/MM/YYYY') "
				+ "    OR b.Abrdatum BETWEEN TO_DATE('" + anreisedatum + "', 'DD/MM/YYYY') AND TO_DATE('" + abreisedatum
				+ "', 'DD/MM/YYYY') " + "    OR b.Anrdatum < TO_DATE('" + anreisedatum
				+ "', 'DD/MM/YYYY') AND b.Abrdatum > TO_DATE('" + abreisedatum + "', 'DD/MM/YYYY')) ";

		if (ausstattungen.length() > 0)
			return query + "AND f.Fwid IN (SELECT fw.Fwid FROM Besitztausstattung fw WHERE fw.Ausstattungname = '"
					+ ausstattungen + "') " + "GROUP BY f.Fwname, f.fwid " + "ORDER BY AVG(b.AnzSterne) DESC";
		else
			return query + "GROUP BY f.Fwname, f.fwid ORDER BY AVG(b.AnzSterne) DESC";
	}

	private static String BuchenVonFerienwohnung(BufferedReader in, Statement stmt)
			throws IOException, SQLException, ParseException
	{
		System.out.println("Email:");
		String email = in.readLine();
		System.out.println("Ferienwohnung:");
		String ferienwohnung = in.readLine();
		System.out.println("Anreisedatum(11/11/2019):");
		String anreisedatum = in.readLine();
		System.out.println("Abreisedatum(11/11/2019):");
		String abreisedatum = in.readLine();

		SimpleDateFormat formatter = new SimpleDateFormat("dd/mm/yyyy");
		Date anDate = formatter.parse(anreisedatum);
		Date abDate = formatter.parse(abreisedatum);

		String query = "SELECT Preis FROM FerienWhng WHERE FWID = '" + ferienwohnung + "'";

		double preis = 0.0;
		ResultSet set = stmt.executeQuery(query);
		while (set.next())
		{
			preis += Double.parseDouble(set.getString(1))
					* ((abDate.getTime() - anDate.getTime()) / (1000 * 60 * 60 * 24));
		}

		return "INSERT INTO Buchung (FwID, Email, BuchDatum, AnrDatum, AbrDatum, RechnungsDatum, RechnungsBetrag) "
				+ "VALUES ('" + ferienwohnung + "', '" + email + "', TO_DATE(SYSDATE, 'DD/MM/YYYY'), TO_DATE('"
				+ anreisedatum + "', 'DD/MM/YYYY'), TO_DATE('" + abreisedatum
				+ "', 'DD/MM/YYYY'), TO_DATE(SYSDATE, 'DD/MM/YYYY'), " + preis + ")";
	}
}
