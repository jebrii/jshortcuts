<?php
/**
 * Created by PhpStorm.
 * User: Sven
 * Date: 8/27/2016
 * Time: 12:16 PM
 */


include('../../include.php');

lineout('start');

global $probCount;
$probCount = 0;

$url = 'https://docs.google.com/spreadsheets/d/1nlV1_f6AiIP9DVXE-EFcUFm4dGivHYcqlOrSEnisCnw/export?format=csv&id=1nlV1_f6AiIP9DVXE-EFcUFm4dGivHYcqlOrSEnisCn';

if (($fh = fopen($url, 'r')) !== false) {
    $lineCount = 0;
    while (($data = fgetcsv($fh, 2000, ',')) !== false) {
        list(, $manuf, $model, $name, $priority, , , $prodCD, $img) = $data;
        $lineCount++;

        if ($lineCount == 1)
            continue;
        if (($priority > 2) && ($priority > 1))
            continue;

        $prod = tblProductPeer::findOne($prodCD);

        if ($prod->getName() !== $name)
            $name = makeErr($name);
        if ($prod->getModel() !== $model)
            $model = makeErr($model);
        $co = tblCompanyPeer::findOne($prod->getCompanyCd());
        if ($co->getName() !== $manuf)
            $manuf = makeErr($manuf);


        lineout("$lineCount) data  manuf[$manuf] model[$model] name[$name] prio[$priority] prodCD[$prodCD] image", $prod->getImage());
        echo('<img src="/Factory/images/products/' . $prod->getImage() . '" style="width:42px;height:42px;border:1;"/>');
    }

} else {
    lineout("file didn't open");
}

lineout('done.  Problem Counter = ', $probCount);


function makeErr($s)
{
    global $probCount;
    $probCount++;
    return ("<span style='color:red'>$s</span>");
}
