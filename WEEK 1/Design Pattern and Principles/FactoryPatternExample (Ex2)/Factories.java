abstract class DocumentFactory 
{
    public abstract Document createDocument();
}
 
class WordFactory extends DocumentFactory 
{
    @Override
    public Document createDocument() 
    {
        return new WordDocument();
    }
}
 
class PdfFactory extends DocumentFactory 
{
    @Override
    public Document createDocument() 
    {
        return new PdfDocument();
    }
}
 
class ExcelFactory extends DocumentFactory 
{
    @Override
    public Document createDocument() {
        return new ExcelDocument();
    }
}