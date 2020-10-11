//Brandon Amisael Garrido Ramírez
//Carnet 19421
//Proyecto Cajero Automático

//Flip flop tipo D
module FlipFlopD(input wire clock, reset, input wire D, output reg Y);
  always @ (posedge clock, posedge reset) begin
      if (reset) begin
        Y <= 1'b0;
      end
      else begin
        Y <= D;
      end
    end
endmodule

// contador inverso desde 111 base 2, 7 en base 10 hasta cero
// la entrada retiro, sustituye la señal del clock en el contador
module Down_Counter(input wire retiro, reset, output reg[2:0] count);
  initial count = 3'b111;
  always @ (posedge retiro or posedge reset) begin
    if(reset) begin
     count <= 3'b111;
    end
    else begin
     count <= count - 3'd1;
    end
  end
endmodule


//FSM Antirebote
module FSMAntirebote (input wire Push, clock, reset, output wire Y);
  wire AS, NS; // Actual State, Next State
  //instanciacion del flip flop a utilizar en la máquina
  FlipFlopD FF1(clock, reset, NS, AS);
  //asignación para estado futuro
  assign NS = Push;
  //asignación para salida
  assign Y = ~AS & Push;
endmodule


//FSM Retiro
module FSMRetiro (input wire Pulso, clock, reset, output wire Y);
  wire AS1, NS1; // Actual State, Next State
  wire AS2, NS2; // Actual State, Next State
  //instanciacion del flip flop a utilizar en la máquina
  FlipFlopD FF1(clock, reset, NS1, AS1);
  FlipFlopD FF2(clock, reset, NS2, AS2);
  //asignación para estado futuro
  assign NS1 = ~AS1 & ~AS2 & Pulso;
  assign NS2 = AS1;
  //asignación para salida
  assign Y = AS1;
endmodule


//FSM Login
module FSMLogin (input wire [3:0] Pin, input wire [2:0] Int, input wire clock, reset, output wire [2:0] Display, output wire Login);
  wire AS1, NS1; // Actual State, Next State
  wire AS2, NS2; // Actual State, Next State
  //instanciacion del flip flop a utilizar en la máquina
  FlipFlopD FF1(clock, reset, NS1, AS1);
  FlipFlopD FF2(clock, reset, NS2, AS2);
  //asignación para estado futuro

  assign NS1 = (~AS2 & ~Int[2] & ~Int[1] & Int[0] & ~Pin[3] & ~Pin[2] & Pin[1] & ~Pin[0]) | (AS2 & Int[2] & Int[1] & Int[0] & Pin[3] & ~Pin[2] & ~Pin[1] & Pin[0]) | (AS1 & ~Int[0]) | (AS1 & Pin[0]) | (AS1 & ~Pin[1]) | (AS1 & Pin[3]) | (AS1 & ~Int[1]) | (AS1 & Int[2]) | (AS1 & ~Pin[2]) | (AS2 & AS1) ;
  assign NS2 = (AS1 & ~Int[2] & Int[1] & Int[0] & ~Pin[3] & Pin[2] & Pin[1] & ~Pin[0]) | AS2 ;
  //asignación para salidas
  assign Display[0] = AS2 | AS1;
  assign Display[1] = AS2;
  assign Display[2] = AS2 & AS1;
  assign Login = AS2 & AS1;
endmodule


//FSM Cajero
module FSMCajero (input wire on, contador, login, retiro, consulta, clock, reset, output wire [2:0] Estado, output wire Display_Saldo);
  wire AS1, NS1; // Actual State, Next State
  wire AS2, NS2; // Actual State, Next State
  wire AS3, NS3; // Actual State, Next State
  //instanciacion del flip flop a utilizar en la máquina
  FlipFlopD FF1(clock, reset, NS1, AS1);
  FlipFlopD FF2(clock, reset, NS2, AS2);
  FlipFlopD FF3(clock, reset, NS3, AS3);
  //asignación para estado futuro

  assign NS1 = (AS2 & AS1 & on & contador) | (~AS2 & ~AS1 & on & contador) | (~AS2 & AS1 & on & ~contador) | (~AS2 & AS1 & ~contador & ~login & ~consulta & ~retiro) | (AS1 & on & contador & ~login)  | (~AS1 & on & contador & ~consulta & retiro);
  assign NS2 = (~AS2 & AS1 & on & contador & login)  | (AS2 & ~AS1 & on & contador & ~consulta) | (AS2 & ~AS1 & on & contador & retiro);
  assign NS3 = AS2 & ~AS1 & on & contador & consulta & ~retiro;
  //asignación para salidas
  assign Estado[0] = AS3 | (AS1 & ~AS2);
  assign Estado[1] = ~AS1 & AS2;
  assign Estado[2] = AS3 | (AS1 & AS2);
  assign Display_Saldo = AS3;
endmodule


//Union de todas las FSM, Máquina completa cajero automático
module FSMCajeroAutomatico(input wire clock, reset, on, push1, push2, input wire [3:0] password, input wire [2:0] checks,
output wire Login, Encendido, pulso, Display_Saldo, Vacio, output wire [2:0] Display_Login, output wire [2:0] Saldo);
  wire contador, rese, retiro, consulta, Signal;
  wire [2:0] Estado;


  assign pulso = ~Estado[0] & ~Estado[1] & Estado[2];
  assign Encendido = Estado[0] | Estado[1] | Estado[2];
  assign Vacio = ~Saldo[0] & ~Saldo[1] & ~Saldo[2];
  assign contador = Saldo[0] | Saldo[1] | Saldo[2];

  FSMCajero cajero(on, contador, Login, retiro, consulta, clock, reset, Estado, Display_Saldo);
  FSMLogin logged(password,checks, clock, reset, Display_Login, Login);
  FSMRetiro retirar(pulso, clock, reset, Signal);
  Down_Counter counter(Signal, reset, Saldo);
  FSMAntirebote antirebote1(push1, clock, reset, retiro);
  FSMAntirebote antirebote2(push2, clock, reset, consulta);

endmodule
