
## D.m
```matlab
function [dist] = D(rt_n,rri_n,r)
% D returns the distance a pulse needs to travel from the transmitter (located at rt_n) 
% to a point (located at r) and back to a receiver (located at rri_n)
```

## D1.m
```matlab
function [dist] = D1(rt_n,rr_n,r)
% D returns the 1st order approximation of the distance a pulse needs to travel from 
% the transmitter (located at rt_n) to a point (located at r) and back to a receiver 
% (located at rr_n)
```

## D2.m
```matlab
function [dist] = D2(rt_n,rr_n,r)
% D returns the 2nd order approximation of the distance a pulse needs to travel from 
% the transmitter (located at rt_n) to a point (located at r) and back to a receiver 
```

## u.m
```matlab
function visible = u(rt_n,rr_n,r)
% returns a 1 if point r is illuminated
```

## sigma_hat.m
```matlab
function sigma_h = sigma_hat(s,rt_n,rr_n,r,f0,f)
% sigma_hat returns the estimated RCS of the point at location r, where 
% the transmitter and receiver at time n are located at rt_n(n,:) and rr_n(n,:)
% respectively.
```
