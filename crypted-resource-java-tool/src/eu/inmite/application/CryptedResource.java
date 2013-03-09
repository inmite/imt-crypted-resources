/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package eu.inmite.application;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.security.SecureRandom;
import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

/**
 *
 * @author petrdvorak
 */
public class CryptedResource {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws FileNotFoundException, IOException {
        
        if (args.length == 0) {
            CryptedResource.printHelp();
        }

        if ("xor".equals(args[0].toLowerCase())) {

            FileInputStream fis = new FileInputStream(args[1]);
            BufferedInputStream bis = new BufferedInputStream(fis);

            FileOutputStream fos = new FileOutputStream(args[2]);
            BufferedOutputStream bos = new BufferedOutputStream(fos);

            byte[] bufferOrig = new byte[1 * 1024 * 1024]; //1MB
            byte[] bufferEncr = new byte[1 * 1024 * 1024]; //1MB
            byte[] symKey = new BASE64Decoder().decodeBuffer(args[3].replaceAll("\n", "")); // see how long the key is

            int readBytes = 0;

            // iterate over the IN and KEY bytes, XOR them and write to OUT
            while (readBytes >= 0) {
                readBytes = bis.read(bufferOrig);
                if (readBytes == -1) {
                    break;
                }
                for (int i = 0; i < readBytes; i++) {
                    bufferEncr[i] = (byte) (bufferOrig[i] ^ symKey[i % symKey.length]);
                }
                bos.write(bufferEncr, 0, readBytes);
                bos.flush();
            }

            fos.close();
            bos.close();

            fis.close();
            bis.close();
        } else if ("gen".equals(args[0].toLowerCase())) {
            byte[] buffer = new byte[Integer.valueOf(args[1])];
            new SecureRandom().nextBytes(buffer);
            System.out.println(new BASE64Encoder().encode(buffer).replaceAll("\n", ""));
        } else {
            CryptedResource.printHelp();
        }
    }

    private static void printHelp() throws IOException {
        InputStream is = Object.class.getResourceAsStream("/eu/inmite/application/resources/help.txt");
        BufferedReader reader = new BufferedReader(new InputStreamReader(is));
        String line = reader.readLine();
        while (line != null) {
            System.out.println(line);
            line = reader.readLine();
        }
    }
}
