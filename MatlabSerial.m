s=serial('COM11')
set(s,'BaudRate',9600)
fopen(s)
fprintf(s,'F','sync');
fprintf(s,'H','sync');
fclose(s)
fwrite(s,'H','sync');
fwrite(s,'F','sync');