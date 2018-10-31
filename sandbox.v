module d_latch (d, q, qbar, wen); 
   input d, wen; 
	 output q, qbar;

		wire dbar, r, s;

		inv1$ inv1 (dbar, d); 
		nand2$ nand1 (s, d, wen); 
		nand2$ nand2 (r, dbar, wen);

	  nand2$ nand3 (q, s, qbar); 
		nand2$ nand4 (qbar, r, q);

endmodule

module  nand2$(out, in0, in1); 
    input   in0, in1; 
	  output  out;
		nand (out, in0, in1);
		specify 
			(in0 *> out) = (0.18:0.2:0.22, 0.18:0.2:0.22);
			(in1 *> out) = (0.18:0.2:0.22, 0.18:0.2:0.22); 
		endspecify 
endmodule
