Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:39047 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbZENRrH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 13:47:07 -0400
Received: by bwz22 with SMTP id 22so1445667bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 14 May 2009 10:47:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b170af450905141043r50c4831eh73999eef98bea7bf@mail.gmail.com>
References: <1242321566.32358.19.camel@rc-desk> <b170af450905141022q29f7a8cfl1c079e473f575c49@mail.gmail.com>
	<1242322940.32358.31.camel@rc-desk> <b170af450905141043r50c4831eh73999eef98bea7bf@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 14 May 2009 19:46:47 +0200
Message-ID: <69e28c910905141046q1e0248b1qb00ad3b9335ed31e@mail.gmail.com>
Subject: Re: [ipw3945-devel] iwlwifi 5150 uCode available
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/5/14 Rafa³ Mi³ecki <zajec5@gmail.com>:
> W dniu 14 maja 2009 19:42 u¿ytkownik reinette chatre
> <reinette.chatre@intel.com> napisa³:
>> Hi,
>>
>> On Thu, 2009-05-14 at 10:22 -0700, Rafa³ Mi³ecki wrote:
>>> 2009/5/14 reinette chatre <reinette.chatre@intel.com>:
>>> > uCode for Intel Wireless WiFi Link 5150AGN is now available for download
>>> > from http://intellinuxwireless.org/?n=Downloads
>>>
>>> Changelog is top secret as usually? ;)
>>
>> Nope ... this is the very first release of this uCode for this
>> particular hardware. A changelog does not make sense in this case.
>>
>>
>>> Should this fix
>>> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1946 (wrong
>>> command queue)?
>>
>>
>> This bug is against 5100/5300 hardware, so this uCode is not what you
>> are looking for. We are working on getting uCode for 5100/5300 hardware
>> (that includes a fix for this bug) out the door.
>>
>> Reinette
>
> Ah, I gone wrong with that numbers understanding. Maybe putting
> supported hardware in ucode's README would be a good idea? :)
> Currently visiting http://intellinuxwireless.org/?n=Downloads doesn't
> provide much help about choosing right firmware for 5100/5300(/5200?).
> Or at last some short info on download page?
>
> --
> Rafa³ Mi³ecki
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Perhaps if this is also for 5350, then instead of naming the FW files
"5000" and "5150", they should be "5x00" and "5x50".

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
