%%%Link: https://stackoverflow.com/questions/14016898/port-matlab-bounding-ellipsoid-code-to-python
% 
% %modeltc1  = [[ 0.53135758, -0.25818091, -0.32382715], 
%     [ 0.58368177, -0.3286576,  -0.23854156,], 
%     [ 0.18741533,  0.03066228, -0.94294771], 
%     [ 0.65685862, -0.09220681, -0.60347573],
%     [ 0.63137604, -0.22978685, -0.27479238],
%     [ 0.59683195, -0.15111101, -0.40536606],
%     [ 0.68646128,  0.0046802,  -0.68407367],
%     [ 0.62311759,  0.0101013,  -0.75863324]];

[A centroid] = minVolEllipse(modeltc1',0.001);
A
[~, D, V] = svd(A);

rx = 1/sqrt(D(1,1));
ry = 1/sqrt(D(2,2));
rz = 1/sqrt(D(3,3));

[u v] = meshgrid(linspace(0,2*pi,20),linspace(-pi/2,pi/2,10));

x = rx*cos(u').*cos(v');
y = ry*sin(u').*cos(v');
z = rz*sin(v');

for idx = 1:20,
    for idy = 1:10,
        point = [x(idx,idy) y(idx,idy) z(idx,idy)]';
        P = V * point;
        x(idx,idy) = P(1)+centroid(1);
        y(idx,idy) = P(2)+centroid(2);
        z(idx,idy) = P(3)+centroid(3);
    end
end

figure
plot3(modeltc1(:,1),modeltc1(:,2),modeltc1(:,3),'.');
hold on;
mesh(x,y,z);
axis square;
alpha 0;



function [A , c] = minVolEllipse(P, tolerance)
[d N] = size(P);

Q = zeros(d+1,N);
Q(1:d,:) = P(1:d,1:N);
Q(d+1,:) = ones(1,N);


count = 1;
err = 1;
u = (1/N) * ones(N,1);


while err > tolerance
    X = Q * diag(u) * Q';
    M = diag(Q' * inv(X) * Q);
    [maximum j] = max(M);
    step_size = (maximum - d -1)/((d+1)*(maximum-1));
    new_u = (1 - step_size)*u ;
    new_u(j) = new_u(j) + step_size;
    count = count + 1;
    err = norm(new_u - u);
    u = new_u;
end

U = diag(u);
A = (1/d) * inv(P * U * P' - (P * u)*(P*u)' );
c = P * u;
end