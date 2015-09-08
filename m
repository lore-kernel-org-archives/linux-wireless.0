Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:32852 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbbIHN7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 09:59:44 -0400
Received: by wiclk2 with SMTP id lk2so121634467wic.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 06:59:42 -0700 (PDT)
Subject: Re: [PATCH] wireless-regdb: add 2.4GHz regulatory rules for Cuba (CU)
To: Seth Forshee <seth.forshee@canonical.com>
References: <1439299795-17359-1-git-send-email-xose.vazquez@gmail.com>
 <20150813143154.GA121347@ubuntu-hedt>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wireless-regdb@lists.infradead.org
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <55EEE9CA.5010309@gmail.com> (sfid-20150908_155952_031705_DC90975E)
Date: Tue, 8 Sep 2015 15:59:38 +0200
MIME-Version: 1.0
In-Reply-To: <20150813143154.GA121347@ubuntu-hedt>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/13/2015 04:31 PM, Seth Forshee wrote:

> On Tue, Aug 11, 2015 at 03:29:55PM +0200, Xose Vazquez Perez wrote:
>> Resolución 127, 2011 - Reglamento Banda 2,4 GHz.:
>> http://www.mincom.gob.cu/sites/default/files/marcoregulatorio/R%20127-11%20Reglamento%20banda%202,4%20GHz.pdf
>>
>> Cc: Seth Forshee <seth.forshee@canonical.com>
>> Cc: linux-wireless@vger.kernel.org
>> Cc: wireless-regdb@lists.infradead.org
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
>>  db.txt | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/db.txt b/db.txt
>> index 982db34..2edbf90 100644
>> --- a/db.txt
>> +++ b/db.txt
>> @@ -275,6 +275,13 @@ country CR: DFS-FCC
>>  	(5490 - 5730 @ 20), (24), DFS
>>  	(5735 - 5835 @ 20), (30)
>>  
>> +# http://www.mincom.gob.cu/?q=marcoregulatorio
>> +# - Redes Informáticas
>> +# Resolución 127, 2011 - Reglamento Banda 2,4 GHz.
>> +country CU: DFS-FCC
>> +	(2400 - 2456 @ 40), (200 mW)
>> +	(2456 - 2483.5 @ 40), (200 mW)
>> +
> 
> Based on the Google translation of the document you linked to, I don't
> see anything which would prevent merging these rules into one rule. Am I
> missing something?

from http://www.mincom.gob.cu/sites/default/files/marcoregulatorio/R%20127-11%20Reglamento%20banda%202,4%20GHz.pdf
page 7:

Artículo 4: Disposiciones de carácter técnico
[..]
4.3.- No obstante lo anterior, los equipos que operen en las frecuencias entre 2456 y
2483,5 MHz pueden emplear valores de p.i.r.e superiores, cuando ello se justifique en
beneficio de objetivos de interés nacional [...]
4.4.- Para estos casos es necesario obtener una autorización expresa de la Agencia
[...]

If you grant an authorization, for 2456-2483.5 pire can be increased.

