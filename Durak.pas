uses WPFObjects, WPFControls, GameClasses;

begin
  window.Width := 700;
  window.Height := 550;
  window.Clear(colors.Gray);
  
  var c := new Coloda(5, 200);
  sleep(500);
  
  var p := new Player(200, 425, 'Ильшат', true);
  c.CToPlayer(p, 6);
  
  var p1 := new Player(200, 50, 'Артур', true);
  c.CToPlayer(p1, 6);
end.