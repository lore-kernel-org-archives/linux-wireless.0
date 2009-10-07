Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:47674 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416AbZJGJie convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 05:38:34 -0400
Received: by bwz6 with SMTP id 6so3963632bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2009 02:37:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200910071134.49515.hs4233@mail.mn-solutions.de>
References: <200910061633.08237.hs4233@mail.mn-solutions.de>
	<1254869377.8034.8.camel@localhost.localdomain> <200910071134.49515.hs4233@mail.mn-solutions.de>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 7 Oct 2009 11:37:35 +0200
Message-ID: <69e28c910910070237y27db9da6s80f428fcbdd623ea@mail.gmail.com>
Subject: Re: [WIP, RFC] libertas: allow scanning via "iw"
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 7, 2009 at 11:34 AM, Holger Schurig
<hs4233@mail.mn-solutions.de> wrote:
>> > * signal isn't reported in dBm or mBm. The scan response from
>> >   the firmware tells me some "RSSI" value.
>>
>> #define MRVDRV_NF_DEFAULT_SCAN_VALUE          (-96)
>> #define SCAN_RSSI(RSSI)                       (0x100 - ((u8)(RSSI)))
>>
>>       iwe.u.qual.level = SCAN_RSSI(bss->rssi);
>>
>>       rssi = iwe.u.qual.level - MRVDRV_NF_DEFAULT_SCAN_VALUE;
>>
>> so it's more or less dBm.
>
> I'm not that sure about that. I made a test and moved with my
> laptop away from an access-point. In the table below you find
> the signal from ipw2200/iwconfig. And in the second column the
> raw "u8 rssi" from libertas' scan response:

What table? Your message ends here...

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
