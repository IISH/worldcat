package org;

import org.xml.sax.SAXException;

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
    private static Validate validate;

    public IISH2WorldCat() {

        try {
            validate = new Validate();
        } catch (SAXException e) {
            e.printStackTrace();
        }

        String[] _transformers = {"/1.normalize.xsl", "/2.sortsubfield.xsl", "/3.removesinglechars.xsl", "/4.removeduplicates.xsl", "/5.rules.xsl"};
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

    private void migrate(String source_folder, String target_folder) throws IOException, TransformerException {

        final File[] source_files = new File(source_folder).listFiles();
        if (source_files == null) {
            System.out.print("The folder has no files: " + source_folder);
            System.exit(-1);
        }

        final File targetFolder = new File(target_folder);
        if (!targetFolder.exists() && !targetFolder.mkdirs()) {
            System.out.print("Failed to create folder " + target_folder);
            System.exit(-1);
        }

        for (File source_file : source_files) {
            final FileInputStream source = new FileInputStream(source_file);

            final int length = (int) source_file.length();
            byte[] record = new byte[length];

            source.read(record, 0, length);

            for (Transformer transformer : transformers) {
                record = convertRecord(transformer, record);
            }

            File target = new File(targetFolder, source_file.getName());
            FileOutputStream fos = new FileOutputStream(target);
            fos.write(record);

            String msg = validate.validate(target);
            if (msg != null) {
                System.out.println("===================================================================");
                System.out.println("Invalid MarcXML: " + target.getAbsolutePath());
                System.out.println(msg);
            }
        }
    }

    private byte[] convertRecord(Transformer transformer, byte[] record) throws TransformerException {

        final StreamSource source = new StreamSource(new ByteArrayInputStream(record));
        final ByteArrayOutputStream baos = new ByteArrayOutputStream();
        transformer.transform(source, new StreamResult(baos));
        return baos.toByteArray();
    }

    /**
     * main
     *
     * @param args 0=source folder; 1=destination folder
     */
    public static void main(String[] args) throws IOException, TransformerException {

        new IISH2WorldCat().migrate(args[0], args[1]);
    }
}
