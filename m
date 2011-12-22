Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44870 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab1LVHrk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 02:47:40 -0500
Received: by qcqz2 with SMTP id z2so4854008qcq.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 23:47:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACna6rxvmFptSR9WF8Whj1A0ATyygQ9Eo0nUY8n6MugQ0bjP7g@mail.gmail.com>
References: <CAG9cJm=YkvHY56LoBoUf3fuh=xb7m+c0GgUzMZX+QyG1+CBCMg@mail.gmail.com>
	<4EF21983.1020107@broadcom.com>
	<CACna6rxEjQLj_j-f7WZOtOEGfDa+TPWyLDrn2t-FGZ5T2_fz-g@mail.gmail.com>
	<CAG9cJm=XE3jQiYvGB4T6_Avj=bmc_wXe8JGMr5hePuCu-OnPuA@mail.gmail.com>
	<CACna6rxvmFptSR9WF8Whj1A0ATyygQ9Eo0nUY8n6MugQ0bjP7g@mail.gmail.com>
Date: Thu, 22 Dec 2011 15:47:39 +0800
Message-ID: <CAG9cJmmnEsLQxxbi41v6nM8D+L_cOSQE73qJmDDYhXPnopn+MA@mail.gmail.com> (sfid-20111222_084743_746950_B91D3EB2)
Subject: Re: bcm4331 firmware installer package
From: lina <lina.lastname@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Debian Lists <debian-user@lists.debian.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 22, 2011 at 3:07 PM, Rafał Miłecki <zajec5@gmail.com> wrote:
> 2011/12/22 lina <lina.lastname@gmail.com>:
>> I am still a bit confused. (First thanks for the links all of you
>> provided, but I have visited those web before).
>>
>> Here is the thing:
>> BCM4331 802.11a/b/g/n fit for
>> BCM4331              b/g  HT (r1)
>>
>> What does the 802.11a for?
>
> Well, your card can operate in 5GHz band (frequencies). But I'm not
>  really sure why you ask about this at all.
>
>  If you want to try experimental BCM4331 support you have to:
>  1) Install kernel 3.2-rc3 or newer
I have the 3.2.0-rc6
>  or
>  2) Install compat wireless
>
>  After that you've do install firmware (check for wiki howto for kernel
>  3.2 and newer).

after installation of the compat-wireless,

from
http://wireless.kernel.org/en/users/Drivers/b43#firmware

 # aptitude install firmware-b43-installer


Setting up b43-fwcutter (1:015-9) ...
Setting up firmware-b43-installer (1:015-9) ...
No chroot environment found. Starting normal installation
Unsupported device(s) found: PCI id 14e4:4331
Aborting.

I don't know which part is wrong here.

Thanks

>
> P.S.
> Please, don't top post.
>
> --
> Rafał
