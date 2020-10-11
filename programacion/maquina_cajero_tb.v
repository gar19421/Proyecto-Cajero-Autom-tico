module testbench();
reg clock, reset, on, push1, push2;
reg [3:0] password;
reg [2:0] checks;
wire Login, Encendido, pulso, Display_Saldo, Vacio;
wire [2:0] Display_Login,Saldo;

always
  begin
    clock <= 1;
    #1 clock <= ~clock;// se realiza el cambio del reloj
    #1;
end

FSMCajeroAutomatico FSM(clock, reset, on, push1, push2, password, checks,
  Login, Encendido, pulso, Display_Saldo, Vacio, Display_Login,Saldo);


initial begin
  $display("Estados FSM Cajero Automatico \n");
  $display("CLK Reset | on push1 push2 password checks|ON  Logeado  Displays_Login Retiro Consulta Sin_Dinero  Saldo");
  $monitor("%b     %b   | %b   %b     %b      %b     %b | %b     %b           %b         %b       %b         %b        %b",
  clock, reset,on,push1,push2,password,checks ,Encendido, Login, Display_Login, pulso, Display_Saldo, Vacio, Saldo);
  #1 reset = 1;   // se realiza el reseteo inicial de la máquina de moore
  #2 on=0; push1=0; push2=0; password[0]=0;password[1]=0;password[2]=0;password[3]=0; checks=000; reset = 0;
  #2 on=0; push1=1; push2=0; password[0]=0;password[1]=0;password[2]=0;password[3]=0; checks=000;
  #2 on=0; push1=0; push2=1; password[0]=0;password[1]=0;password[2]=0;password[3]=0; checks=000;
  #2 on=1; push1=0; push2=0; password[0]=0;password[1]=0;password[2]=0;password[3]=0; checks=000;
  #2 on=1; push1=1; push2=0; password[0]=0;password[1]=0;password[2]=0;password[3]=0; checks=000;
  #2 on=1; push1=0; push2=1; password[0]=0;password[1]=0;password[2]=0;password[3]=0; checks=000; //prueba de encendido

  #2 on=1; push1=0; push2=0; password[0]=0;password[1]=0;password[2]=1;password[3]=0; checks=001;
  #2 on=1; push1=0; push2=0; password[0]=0;password[1]=1;password[2]=0;password[3]=0; checks=011;
  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=1;password[3]=0; checks=111;//prueba login con contraseña erronea

  #2 on=1; push1=0; push2=0; password[0]=0;password[1]=1;password[2]=0;password[3]=0; checks=001;
  #2 on=1; push1=0; push2=0; password[0]=0;password[1]=1;password[2]=1;password[3]=0; checks=011;
  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=1;password[3]=0; checks=111;//prueba login con contraseña semi incorrecta

  #2 on=1; push1=0; push2=0; password[0]=0;password[1]=1;password[2]=0;password[3]=0; checks=001;
  #2 on=1; push1=0; push2=0; password[0]=0;password[1]=1;password[2]=1;password[3]=0; checks=011;
  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;
  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;//prueba login con contraseñas correctas

  #2 on=1; push1=1; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;//prueba de retiro

  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;
  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;//delay que se tarda en retirar o consultar
  #2 on=1; push1=0; push2=1; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;//prueba consulta

  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;
  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;//delay
  #2 on=1; push1=1; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;
  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;
  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;//delay
  #2 on=1; push1=1; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;
  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;
  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;//delay
  #2 on=1; push1=1; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;
  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;
  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;//delay
  #2 on=1; push1=1; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;
  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;
  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;//delay
  #2 on=1; push1=1; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;//prueba de retiro para vaciar cajero
  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;
  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;//delay

  #2 on=1; push1=0; push2=1; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;//prueba de consulta última
  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;
  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;//delay

  #2 on=1; push1=1; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;
  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;//delay
  #2 on=1; push1=0; push2=0; password[0]=1;password[1]=0;password[2]=0;password[3]=1; checks=111;//prueba de vaciar cajero
  #1 $finish;//finalizar prueba de cajero

end

  initial begin
    $dumpfile("maquina_cajero_tb.vcd");// se ejecuta GTKwave
    $dumpvars(0, testbench);
  end

endmodule
