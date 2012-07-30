Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63159 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab2G3E7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2012 00:59:05 -0400
Received: by obbuo13 with SMTP id uo13so8421675obb.19
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jul 2012 21:59:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAT9HsgZnkc32=Wh+GVphYrMvKQ0t=_mtdgC-7h=Za7YFuX24Q@mail.gmail.com>
References: <CAAT9HsjZ7wPbkRMH94HDNBS+vOhLigKLYULqfyQobh_Oyt9M4w@mail.gmail.com>
	<501030E9.3090707@lwfinger.net>
	<CAAT9Hshwb+iPMALGvP1P2UHzEQbyvYNM0_zz0dHp0mJuy6KwLA@mail.gmail.com>
	<50103BE8.1020203@lwfinger.net>
	<CAAT9HsjQ_tkm77NT_Rn5_Pi9BHGhY9Vz7jcVzkwdDUjUoKamtw@mail.gmail.com>
	<501061C8.5010108@lwfinger.net>
	<CA+XFjioVy_pmKxcJAe1U_M+zKNiiPEsb0bmkAfEWzmnnDBjLFw@mail.gmail.com>
	<CAAT9HsgXHe-0qZ5vTvCuU8QZ006MrsCyu7Zc_PRFccz52TWcUw@mail.gmail.com>
	<CAD2nsn2022_CbNtLCy64uFSMF=2PBMN4sDmO4pLbFodLQ139ZQ@mail.gmail.com>
	<CAAT9HsgZnkc32=Wh+GVphYrMvKQ0t=_mtdgC-7h=Za7YFuX24Q@mail.gmail.com>
Date: Mon, 30 Jul 2012 10:29:03 +0530
Message-ID: <CAD2nsn1RLPWp=HujfsRFwnK_5nDNUMFMNtwJ2ZytSYWefP3gGg@mail.gmail.com> (sfid-20120730_065910_455511_7C209E6D)
Subject: Re: New Laptop and Driver
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Tim and Alison Bentley <Home@trarbentley.net>
Cc: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 28, 2012 at 12:01 PM, Tim and Alison Bentley
<Home@trarbentley.net> wrote:
> On 26 July 2012 06:26, Mohammed Shafi <shafi.wireless@gmail.com> wrote:
>>> Jul 26 05:58:23 tigger2 kernel: [ 1546.876477] cfg80211: Calling CRDA
>>> to update world regulatory domain
>>> Jul 26 05:58:23 tigger2 kernel: [ 1546.916447] cfg80211: World
>>> regulatory domain updated:
>>> Jul 26 05:58:23 tigger2 kernel: [ 1546.916450] cfg80211:   (start_freq
>>> - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>>> Jul 26 05:58:23 tigger2 kernel: [ 1546.916453] cfg80211:   (2402000
>>> KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>>> Jul 26 05:58:23 tigger2 kernel: [ 1546.916455] cfg80211:   (2457000
>>> KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>>> Jul 26 05:58:23 tigger2 kernel: [ 1546.916457] cfg80211:   (2474000
>>> KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>>> Jul 26 05:58:23 tigger2 kernel: [ 1546.916459] cfg80211:   (5170000
>>> KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>>> Jul 26 05:58:23 tigger2 kernel: [ 1546.916461] cfg80211:   (5735000
>>> KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>>> Jul 26 05:58:30 tigger2 kernel: [ 1553.767939] ath: phy0: Hardware
>>> device ID 0x0037 not supported
>>> Jul 26 05:58:30 tigger2 kernel: [ 1553.767948] ath9k 0000:03:00.0:
>>> Failed to initialize device
>>> Jul 26 05:58:30 tigger2 kernel: [ 1553.768137] ath9k: probe of
>>> 0000:03:00.0 failed with error -95
>>
>> can you please try the attached dummy patch. see if the device is working.
>> if its a version of AR9485 it should work. if its properly working, we
>> can add a proper support.
>>
>>>
>>>
>>> --
>>> Tim and Alison Bentley
>>> Home@TRARBentley.net
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> thanks,
>> shafi
>
> It works.  Sorry for the delay in replying but I needed to learn how
> to compile a Kernel.
> Patched the 3.4.6.2 fedora kernel and now Wireless works from boot up.

sorry, i missed this thread.  thanks for spending time and checking this out.
I will send a patch to wireless-testing.
just curious, I don't have the device, is it possible for you to post
the logs enabling all the ath9k debug
with some traffic running
http://linuxwireless.org/en/users/Drivers/ath9k/debug.
Please initially post the kernel logs when wifi boots up, just need to
ensure its a proper
AR9485.

>
> Any chance this could be fixed in the 3.5 series Kernels as Fedora is
> rolling these out.


I could cc the patch to stable kernel.

>
> Thanks.
>
> --
> Tim and Alison Bentley
> Home@TRARBentley.net



-- 
thanks,
shafi
