<?
if (ereg("^[0-9]+$", $_SERVER["QUERY_STRING"]))
{
  require("/opt/liquid_feedback_core/constants.php");

  $dbconn = pg_connect("dbname=lfbot") or die('Verbindungsaufbau fehlgeschlagen: ' . pg_last_error());

  $query = "SELECT forum FROM reddit_map WHERE lqfb = '" . $_SERVER["QUERY_STRING"] . "' LIMIT 1;";
  $result = pg_query($query) or die('Abfrage fehlgeschlagen: ' . pg_last_error());
  $tid = 0;
  while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
    $tid = $line["forum"];
  }
  pg_free_result($result);

  pg_close($dbconn);
  header("Location: https://reddit.piratenpartei.at/r/Allgemein/comments/$tid");
}
?>
