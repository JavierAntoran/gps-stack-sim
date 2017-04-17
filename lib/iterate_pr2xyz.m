function [ A, Delta_X, Pos_Rcv_n] = iterate_pr2xyz( pSV, Pos_Rcv, pr )

[nSV,n]=size(pSV);

distxyz = pSV - repmat(Pos_Rcv,nSV,1);
d_sat = sqrt(sum(abs(distxyz).^2,2));
unitdist = distxyz./repmat(d_sat,1 , 3);

A=[-unitdist ones(nSV,1)];
delta_pr = pr' - d_sat;

Delta_X=inv(A'*A)*A'*delta_pr;
Pos_Rcv_n=(Pos_Rcv'+Delta_X(1:3))';
end

