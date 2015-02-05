package org;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.net.URL;
import java.util.ArrayList;

public class IISH2WorldCat {


    final TransformerFactory tf = TransformerFactory.newInstance();
    @SuppressWarnings("unchecked")
    private ArrayList<Transformer> transformers = new ArrayList(2);

    public IISH2WorldCat() {

        String[] _transformers = {"/1.normalize.xsl", "/2.rules.xsl"};
        for (String _transformer : _transformers) {

            final URL resource = this.getClass().getResource(_transformer);
            Source source = null;
            try {
                source = new StreamSource(resource.openStream());
            } catch (IOException e) {
                System.err.println(e.getMessage());
                System.exit(-1);
            }

            source.setSystemId(resource.toString());
            try {
                transformers.add(tf.newTransformer(source));
            } catch (TransformerConfigurationException e) {
                System.err.println(e.getMessage());
                System.exit(-1);
            }
        }

    }

    private void migrate(String source_folder, String target_folder) {

        final File[] source_files = new File(source_folder).listFiles();
        final File targetFolder = new File(target_folder);
        if (!targetFolder.exists()) {
            System.out.print("Creating " + targetFolder + targetFolder.mkdirs());
        }

        if (source_files == null) return;
        for (File source_file : source_files) {
            final Source source = new StreamSource(source_file);
            File target = new File(targetFolder, source_file.getName());
            FileOutputStream fos;
            try {
                fos = new FileOutputStream(target);
            } catch (FileNotFoundException e) {
                System.err.println(source_file.getAbsolutePath());
                System.err.println(e.getMessage());
                continue;
            }


            for (Transformer transformer : transformers) {
                final ByteArrayOutputStream baos = new ByteArrayOutputStream();
                final StreamResult result = new StreamResult(baos);
                try {
                    transformer.transform(source, result);
                    transformer.reset();
                } catch (TransformerException e) {
                    System.err.println(e.getMessage());
                }

                try {
                    fos.write(baos.toByteArray());
                } catch (IOException e) {
                    System.err.println(e.getMessage());
                }

            }
        }
    }

    /**
     * main
     *
     * @param args 0=source folder; 1=destination folder
     */
    public static void main(String[] args) {

        new IISH2WorldCat().migrate(args[0], args[1]);
    }
}
