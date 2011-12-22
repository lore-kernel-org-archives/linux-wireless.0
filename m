Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43285 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab1LVJJS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 04:09:18 -0500
Received: by qcqz2 with SMTP id z2so4882984qcq.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Dec 2011 01:09:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACna6ryy3VaL4u=fts4q0KGxXp0NibMcBaS7tnYbAG5w06sj1Q@mail.gmail.com>
References: <CAG9cJm=YkvHY56LoBoUf3fuh=xb7m+c0GgUzMZX+QyG1+CBCMg@mail.gmail.com>
	<4EF21983.1020107@broadcom.com>
	<CACna6rxEjQLj_j-f7WZOtOEGfDa+TPWyLDrn2t-FGZ5T2_fz-g@mail.gmail.com>
	<CAG9cJm=XE3jQiYvGB4T6_Avj=bmc_wXe8JGMr5hePuCu-OnPuA@mail.gmail.com>
	<CACna6rxvmFptSR9WF8Whj1A0ATyygQ9Eo0nUY8n6MugQ0bjP7g@mail.gmail.com>
	<CAG9cJmmnEsLQxxbi41v6nM8D+L_cOSQE73qJmDDYhXPnopn+MA@mail.gmail.com>
	<CACna6rw_zB038mJ5XP6qvZR61pB77yRes3UwM50JFawUAhUpYg@mail.gmail.com>
	<CAG9cJmkn9HRM1TWL_P0SHBjx9mG4gZYDXeL=HucSg1FK4bf0JQ@mail.gmail.com>
	<CACna6ryy3VaL4u=fts4q0KGxXp0NibMcBaS7tnYbAG5w06sj1Q@mail.gmail.com>
Date: Thu, 22 Dec 2011 17:09:17 +0800
Message-ID: <CAG9cJmmWgoQKfoKcj-Ew=0gKX=akWzVidFJx-XnxM7=snGEo5A@mail.gmail.com> (sfid-20111222_100923_547466_F549EC9D)
Subject: Re: bcm4331 firmware installer package
From: lina <lina.lastname@gmail.com>
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Debian Lists <debian-user@lists.debian.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wow ... I reboot.

Historically the first time the wireless can work.

Thanks, I am going to celebrate it by bring my laptop to canteen for
dinner. (it's a joke).

Thanks all again,

Best regards,


On Thu, Dec 22, 2011 at 4:49 PM, Rafa³ Mi³ecki <zajec5@gmail.com> wrote:
> W dniu 22 grudnia 2011 09:45 u¿ytkownik lina <lina.lastname@gmail.com> napisa³:
>> On Thu, Dec 22, 2011 at 4:34 PM, Rafa³ Mi³ecki <zajec5@gmail.com> wrote:
>>> 2011/12/22 lina <lina.lastname@gmail.com>:
>>>> On Thu, Dec 22, 2011 at 3:07 PM, Rafa³ Mi³ecki <zajec5@gmail.com> wrote:
>>>>> 2011/12/22 lina <lina.lastname@gmail.com>:
>>>>>> I am still a bit confused. (First thanks for the links all of you
>>>>>> provided, but I have visited those web before).
>>>>>>
>>>>>> Here is the thing:
>>>>>> BCM4331 802.11a/b/g/n fit for
>>>>>> BCM4331              b/g  HT (r1)
>>>>>>
>>>>>> What does the 802.11a for?
>>>>>
>>>>> Well, your card can operate in 5GHz band (frequencies). But I'm not
>>>>>  really sure why you ask about this at all.
>>>>>
>>>>>  If you want to try experimental BCM4331 support you have to:
>>>>>  1) Install kernel 3.2-rc3 or newer
>>>> I have the 3.2.0-rc6
>>>>>  or
>>>>>  2) Install compat wireless
>>>>>
>>>>>  After that you've do install firmware (check for wiki howto for kernel
>>>>>  3.2 and newer).
>>>>
>>>> after installation of the compat-wireless,
>>>>
>>>> from
>>>> http://wireless.kernel.org/en/users/Drivers/b43#firmware
>>>>
>>>>  # aptitude install firmware-b43-installer
>>>>
>>>>
>>>> Setting up b43-fwcutter (1:015-9) ...
>>>> Setting up firmware-b43-installer (1:015-9) ...
>>>> No chroot environment found. Starting normal installation
>>>> Unsupported device(s) found: PCI id 14e4:4331
>>>> Aborting.
>>>>
>>>> I don't know which part is wrong here.
>>>
>>> Your tool is too old (support for BCM4331 is really recent).
>> sorry, here you mean, which tool?
>>>
>>> Just do as I said and use howto for kernel 3.2, not distro-specific
>>> howto. You nede to install b43-fwcutter and manually download file for
>> I can't tell the difference. (I really need detailed instructions,
>> thanks for your patience ahead)
>>
>> I tried to follow what you said before, with the kernel 3.2-rc6
>> install the compate-wireless,
>> but have problem in the following install the firmware-installer.
>>> firmware extraction.
>
> wget http://bu3sch.de/b43/fwcutter/b43-fwcutter-015.tar.bz2
> tar xjf b43-fwcutter-015.tar.bz2
> cd b43-fwcutter-015
> make
> sudo make install
> cd ..
>
> export FIRMWARE_INSTALL_DIR="/lib/firmware"
> wget http://www.lwfinger.com/b43-firmware/broadcom-wl-5.100.138.tar.bz2
> tar xjf broadcom-wl-5.100.138.tar.bz2
> sudo b43-fwcutter -w "$FIRMWARE_INSTALL_DIR"
> broadcom-wl-5.100.138/linux/wl_apsta.o
>
> --
> Rafa³
