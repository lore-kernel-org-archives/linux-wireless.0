Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50510 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934928Ab0KQRPX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 12:15:23 -0500
Received: by vws13 with SMTP id 13so1089524vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 09:15:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=1RFZwRYvA=VfuKTQS6YwZkTv17Q0nnWnQW3Hq@mail.gmail.com>
References: <AANLkTik+BWQdU4hhKN7yfgOdJuQXopvYr4Z59RTntqSW@mail.gmail.com>
	<1289607742.21000.23.camel@dcbw.foobar.com>
	<AANLkTi=1RFZwRYvA=VfuKTQS6YwZkTv17Q0nnWnQW3Hq@mail.gmail.com>
Date: Wed, 17 Nov 2010 20:15:22 +0300
Message-ID: <AANLkTinKMfu2SX2fymUDi3JooAwKZv7=41BQBywR3pVe@mail.gmail.com>
Subject: Re: Bringing up Marvell 88W8300
From: Denis Kirjanov <kirjanov@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	dwmw2@infradead.org, David.Woodhouse@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> I will try to load the firmware that comes with the driver source.
>
>> Does that sound like a plan?  I have no time for it, but I'm happy to
>> put the driver up somewhere that others can make use of it.  I'll
>> recheck the provenience of the driver but it's got MODULE_LICENSE("GPL")
>> and GPL headers all over, including on the firmware file.  I might have
>> grabbed it off the Extranet but I'll check.
>>
Marvell firmware is OK for me and I can successfully boot in .
I believe that we can now port driver to the new wireless stuff such
as cfg80211.

@David, is it possible to use infraded.org form mrv8k as it was before?


-- 
Regards,
Denis
