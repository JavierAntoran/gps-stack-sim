function dTclk_Rel=Error_Satellite_Clock_Relavastic(F,ec,A,E,Tgd)
dTclk_Rel=F.*ec.*sqrt(A).*sin(E)-Tgd;
end