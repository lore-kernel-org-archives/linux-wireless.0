Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:32795 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbcA0J6C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 04:58:02 -0500
Received: by mail-wm0-f46.google.com with SMTP id 123so143976773wmz.0
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jan 2016 01:58:01 -0800 (PST)
Subject: Re: [PATCH] wireless-regdb: add 2.4GHz regulatory rules for Cuba (CU)
To: Seth Forshee <seth.forshee@canonical.com>
References: <1439299795-17359-1-git-send-email-xose.vazquez@gmail.com>
 <20150813143154.GA121347@ubuntu-hedt> <55EEE9CA.5010309@gmail.com>
 <20150908142208.GB26645@ubuntu-hedt>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wireless-regdb@lists.infradead.org
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <56A894A5.4040306@gmail.com> (sfid-20160127_105813_664923_900BE3C5)
Date: Wed, 27 Jan 2016 10:57:57 +0100
MIME-Version: 1.0
In-Reply-To: <20150908142208.GB26645@ubuntu-hedt>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/08/2015 04:22 PM, Seth Forshee wrote:
> On Tue, Sep 08, 2015 at 03:59:38PM +0200, Xose Vazquez Perez wrote:
>> On 08/13/2015 04:31 PM, Seth Forshee wrote:
>>
>>> On Tue, Aug 11, 2015 at 03:29:55PM +0200, Xose Vazquez Perez wrote:
>>>> Resolución 127, 2011 - Reglamento Banda 2,4 GHz.:
>>>> http://www.mincom.gob.cu/sites/default/files/marcoregulatorio/R%20127-11%20Reglamento%20banda%202,4%20GHz.pdf
>>>>
>>>> Cc: Seth Forshee <seth.forshee@canonical.com>
>>>> Cc: linux-wireless@vger.kernel.org
>>>> Cc: wireless-regdb@lists.infradead.org
>>>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>>>> ---
>>>>  db.txt | 7 +++++++
>>>>  1 file changed, 7 insertions(+)
>>>>
>>>> diff --git a/db.txt b/db.txt
>>>> index 982db34..2edbf90 100644
>>>> --- a/db.txt
>>>> +++ b/db.txt
>>>> @@ -275,6 +275,13 @@ country CR: DFS-FCC
>>>>  	(5490 - 5730 @ 20), (24), DFS
>>>>  	(5735 - 5835 @ 20), (30)
>>>>  
>>>> +# http://www.mincom.gob.cu/?q=marcoregulatorio
>>>> +# - Redes Informáticas
>>>> +# Resolución 127, 2011 - Reglamento Banda 2,4 GHz.
>>>> +country CU: DFS-FCC
>>>> +	(2400 - 2456 @ 40), (200 mW)
>>>> +	(2456 - 2483.5 @ 40), (200 mW)
>>>> +
>>>
>>> Based on the Google translation of the document you linked to, I don't
>>> see anything which would prevent merging these rules into one rule. Am I
>>> missing something?
>>
>> from http://www.mincom.gob.cu/sites/default/files/marcoregulatorio/R%20127-11%20Reglamento%20banda%202,4%20GHz.pdf
>> page 7:
>>
>> Artículo 4: Disposiciones de carácter técnico
>> [..]
>> 4.3.- No obstante lo anterior, los equipos que operen en las frecuencias entre 2456 y
>> 2483,5 MHz pueden emplear valores de p.i.r.e superiores, cuando ello se justifique en
>> beneficio de objetivos de interés nacional [...]
>> 4.4.- Para estos casos es necesario obtener una autorización expresa de la Agencia
>> [...]
>>
>> If you grant an authorization, for 2456-2483.5 pire can be increased.
> 
> Okay, but for the purposes of this database that provision isn't going
> to apply, and it seems you agree since you've listed both as having the
> exact same power limit. So I'd still prefer that we make it a single
> rule.

OK. Done in v2.

-thanks-
