Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55634 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab1DJWhf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 18:37:35 -0400
Received: by iwn34 with SMTP id 34so5086740iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Apr 2011 15:37:34 -0700 (PDT)
Message-ID: <4DA2312B.8080303@lwfinger.net>
Date: Sun, 10 Apr 2011 17:37:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: Ben Hutchings <ben@decadent.org.uk>, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org
Subject: Re: Firmware files for Ralink RT28x0
References: <4DA2042A.3010301@gmail.com> <1302469406.5282.341.camel@localhost> <4DA22545.6050209@gmail.com>
In-Reply-To: <4DA22545.6050209@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/10/2011 04:46 PM, Xose Vazquez Perez wrote:
> On 04/10/2011 11:03 PM, Ben Hutchings wrote:
>
>> These files aren't used by the Ralink drivers.  So why should you
>> believe the labels on them?
>
> Because the hardware manufacturer says that:
> http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-March/003380.html
>
> Anyway, the firmware in staging(or ralink web) drivers look different because
> they are different _versions_ of the _same_ firmware.
>
> rt2870.bin: before 4096 bytes, now 8192 bytes.
>
>> linux-firmware is not *actively* maintained; it requires people to send
>> submissions (repeatedly...).
>
> On 04/06/2010, *ONE YEAR AGO* , I sent a patch to rt2870.bin rt2860.bin.
> It went to /dev/null
>
> A similar patch was sent by the *driver maintainer* on 10/30/2010.
> It went to /dev/null
>
> The same patch was sent by the *hardware manufacturer* on 03/11/2011
> It went to /dev/null
>
> Torvalds, Mozart and God are pending.
>
>> I think there may be a problem with distribution of Intel Pro Wireless
>> firmware because Intel requires users to accept a EULA.
>
> If it's included in Fedora then there are zero issues with licenses.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Do you still have the patch from one year ago? I would like to see what you 
proposed in changes to WHENCE.

Larry
