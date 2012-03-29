Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59869 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758421Ab2C2Nik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2012 09:38:40 -0400
Received: by wibhj6 with SMTP id hj6so67401wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2012 06:38:39 -0700 (PDT)
Date: Thu, 29 Mar 2012 15:38:35 +0200
From: =?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>,
	"jrnieder@gmail.com" <jrnieder@gmail.com>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: Re: brcmsmac still woes, possible regression?
Message-ID: <20120329133835.GA5196@stt008.linux.site> (sfid-20120329_153844_594301_416AAB88)
References: <4F7035AD.1080503@broadcom.com> <20120326094331.GA4856@stt008.linux.site> <4F70409E.3090203@broadcom.com> <CAKprTDGdbUnXtbfmck9rtYfKeD71xSXjShW6HnxyZJ8uRZEfnQ@mail.gmail.com> <4F717EA1.4060805@broadcom.com> <4F72F3D4.50409@broadcom.com> <20120328112657.GA6114@stt008.linux.site> <4F7302D9.8070009@broadcom.com> <CAKprTDHz0d=W1472KcHuD-Zda9dCUX+5nKfEX55UfiNBeQ7T2w@mail.gmail.com> <4F744DD8.8010004@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4F744DD8.8010004@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El 2012-03-29 a las 13:56 +0200, Arend van Spriel escribió:
> On 03/28/2012 11:59 PM, Camaleón wrote:
>> 2012/3/28 Arend van Spriel<arend@broadcom.com>:
>>> On 03/28/2012 01:26 PM, Camaleón wrote:
>>
>>>>> Did you have any opportunity to test the patch?

(...)

>> Here it goes.
>>
>> There's another trace, so now I doubt that I have applied the patches
>> correctly... Mmm, how could check if the brcmsmac module which I have
>> compiled and loaded has the patch applied? :-?
>>
>> Greetings,
>>
>
> So you have 3.3 kernel sources. Is that from a tarball or are you using  
> git? For git it would be pretty easy to verify you have the patch.

I have the sources, so I applied the patch ("patch -p1 < file.patch") 
and then compiled the full kernel again. I can see the three files 
(channel.c, main.c and main.h) have been modified but I'm unsure.

Greetings,

-- 
Camaleón 
