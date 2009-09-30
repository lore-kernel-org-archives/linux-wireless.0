Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:51301 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbZI3BTh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 21:19:37 -0400
Received: by ewy7 with SMTP id 7so5998752ewy.17
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2009 18:19:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69e28c910909291127x3be75be0r3ceef7367d05f9c3@mail.gmail.com>
References: <200909260457.21103.malte.gell@gmx.de>
	 <4ABDE7AC.1090409@hauke-m.de> <200909291050.54388.malte.gell@gmx.de>
	 <3ace41890909290200h4dbefddah131851675dc06097@mail.gmail.com>
	 <69e28c910909291127x3be75be0r3ceef7367d05f9c3@mail.gmail.com>
Date: Wed, 30 Sep 2009 02:19:41 +0100
Message-ID: <3ace41890909291819x4f01c6c9p475ea3a4bb075342@mail.gmail.com>
Subject: Re: cannot compile compate-wirless snapshots
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Malte Gell <malte.gell@gmx.de>, Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/9/29 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Tue, Sep 29, 2009 at 11:00 AM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:

>> The relevant config is probably /boot/config-`uname -r`, but, please
>> do *not* modify it.
>>
>
> It should be in /proc/config.gz. (/boot/config-* is an Ubuntuism.)

John pointed out Fedora & RHEL does /boot/config-*  . (and don't
provide /proc/config.gz). I don't know which distro does
/proc/config.gz Obviously neither Ubuntu nor Fedora/RHEL; maybe one of
Mandriva/Debian/Suse?

As a point of interest, /boot also contains the init ramdisk, the
kernel symbol map besides the kernel image (beside some
grub/boot-loader files), so it isn't too much to have another kernel
related file. For the purist, building the kernel to have
self-knowledge of its own config under /proc is a neat thing, but
OTOH, it uses kernel memory to provide what is very static unchanging
info under /proc, which is unwise.
