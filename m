Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61161 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab1LVIev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 03:34:51 -0500
Received: by wibhm6 with SMTP id hm6so2374915wib.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Dec 2011 00:34:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG9cJmmnEsLQxxbi41v6nM8D+L_cOSQE73qJmDDYhXPnopn+MA@mail.gmail.com>
References: <CAG9cJm=YkvHY56LoBoUf3fuh=xb7m+c0GgUzMZX+QyG1+CBCMg@mail.gmail.com>
	<4EF21983.1020107@broadcom.com>
	<CACna6rxEjQLj_j-f7WZOtOEGfDa+TPWyLDrn2t-FGZ5T2_fz-g@mail.gmail.com>
	<CAG9cJm=XE3jQiYvGB4T6_Avj=bmc_wXe8JGMr5hePuCu-OnPuA@mail.gmail.com>
	<CACna6rxvmFptSR9WF8Whj1A0ATyygQ9Eo0nUY8n6MugQ0bjP7g@mail.gmail.com>
	<CAG9cJmmnEsLQxxbi41v6nM8D+L_cOSQE73qJmDDYhXPnopn+MA@mail.gmail.com>
Date: Thu, 22 Dec 2011 09:34:50 +0100
Message-ID: <CACna6rw_zB038mJ5XP6qvZR61pB77yRes3UwM50JFawUAhUpYg@mail.gmail.com> (sfid-20111222_093455_035499_0F67785D)
Subject: Re: bcm4331 firmware installer package
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: lina <lina.lastname@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Debian Lists <debian-user@lists.debian.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/12/22 lina <lina.lastname@gmail.com>:
> On Thu, Dec 22, 2011 at 3:07 PM, Rafał Miłecki <zajec5@gmail.com> wrote:
>> 2011/12/22 lina <lina.lastname@gmail.com>:
>>> I am still a bit confused. (First thanks for the links all of you
>>> provided, but I have visited those web before).
>>>
>>> Here is the thing:
>>> BCM4331 802.11a/b/g/n fit for
>>> BCM4331              b/g  HT (r1)
>>>
>>> What does the 802.11a for?
>>
>> Well, your card can operate in 5GHz band (frequencies). But I'm not
>>  really sure why you ask about this at all.
>>
>>  If you want to try experimental BCM4331 support you have to:
>>  1) Install kernel 3.2-rc3 or newer
> I have the 3.2.0-rc6
>>  or
>>  2) Install compat wireless
>>
>>  After that you've do install firmware (check for wiki howto for kernel
>>  3.2 and newer).
>
> after installation of the compat-wireless,
>
> from
> http://wireless.kernel.org/en/users/Drivers/b43#firmware
>
>  # aptitude install firmware-b43-installer
>
>
> Setting up b43-fwcutter (1:015-9) ...
> Setting up firmware-b43-installer (1:015-9) ...
> No chroot environment found. Starting normal installation
> Unsupported device(s) found: PCI id 14e4:4331
> Aborting.
>
> I don't know which part is wrong here.

Your tool is too old (support for BCM4331 is really recent).

Just do as I said and use howto for kernel 3.2, not distro-specific
howto. You nede to install b43-fwcutter and manually download file for
firmware extraction.

-- 
Rafał
