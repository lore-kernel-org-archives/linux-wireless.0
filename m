Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:34657 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321AbcDLLuA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 07:50:00 -0400
Received: by mail-oi0-f45.google.com with SMTP id s79so18695673oie.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2016 04:49:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <570CB818.9080807@broadcom.com>
References: <1460367328-12082-1-git-send-email-arend@broadcom.com>
 <CACna6rwCe6yfzcxdezKhPJwJ4cnWY4DEE04W81K=PrVD1pZVoA@mail.gmail.com> <570CB818.9080807@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 12 Apr 2016 21:49:39 +1000
Message-ID: <CAGRGNgUN+vGjnHc=nNci5pshTmizaNzbqy=YJz7-iDRtHCay3A@mail.gmail.com> (sfid-20160412_135006_502352_71E33B4F)
Subject: Re: [PATCH 0/8] brcmfmac: event handling and other fixes
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Tue, Apr 12, 2016 at 6:55 PM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 11-04-16 13:20, Rafał Miłecki wrote:
>> On 11 April 2016 at 11:35, Arend van Spriel <arend@broadcom.com> wrote:
>>> This series provides the following:
>>>
>>> * avoid unexpected firmware events.
>>> * allow passing events explicitly for PCIe and SDIO devices.
>>> * fix issue with boardrev entry in nvram.
>>> * fix for wowl.
>>> * fix possible null pointer access upon aborting p2p scan.
>>>
>>> The series is intended for v4.7 kernel and applies to the master
>>> branch of the wireless-drivers-next repository.
>>
>> Hey Arend,
>>
>> Unfortunately I'm finding all your recent messages in spam :( It seems
>> GMail doesn't like something about the Broadcom server:
>> "Why is this message in Spam? It has a from address in broadcom.com
>> but has failed broadcom.com's required tests for authentication. Learn
>> more"
>> Quoted "Learn more" text links to the:
>> https://support.google.com/mail/answer/1366858?hl=en-GB&expand=5
>>
>> Do you think you can point it to sb at Broadcom?
>
> sb? Help me understand this and I may have an appropriate answer :-p
>
> Broadcom actually moved to Google Apps. I am still using my old email
> address and smtp server for submitting patches. Maybe that is the issue
> here.

That's the issue. IIRC this happens because the emails are missing
some header that authenticates them as actually being from
broadcom.com. (I get this all the time when sending Debian bug reports
through my personal SMTP server.)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
