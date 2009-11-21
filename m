Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:43676 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050AbZKUQCG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Nov 2009 11:02:06 -0500
Received: by gxk26 with SMTP id 26so3737825gxk.1
        for <linux-wireless@vger.kernel.org>; Sat, 21 Nov 2009 08:02:12 -0800 (PST)
Message-ID: <4B080EFA.6000300@w1an.in>
Date: Sat, 21 Nov 2009 08:02:02 -0800
From: Balaji Ravindran <b@w1an.in>
MIME-Version: 1.0
To: Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Kernel compilation Question
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I tried compiling the wireless 2.6 kernel on my debian machine using
make-kpkg and being lazy, i just did make defconfig, and saw that my
compilation went fine without any issues, but i noticed that there was
no ramdisk image that was generated when i installed the linux-image*.deb.

i did use --initrd option,

Was it because, using make defconfig compiles everything on the kernel
itself? Aren't there any 'm' option in defaults?(dunno just asking if
this is the case)

or did i miss something out

Please see if i missed some step

Summary of steps performed.

extracted wireless 2.6 source onto /usr/src

created symbolic link

make defconfig (i did not copy my existing config file to .config, i
just wanted to try out make defconfig option)

make-kpkg --initrd --append-to-version=foo --revision=bar kernel_image
modules_image kernel_headers

this created 2 files linux-image* and linux-headers*, i was missing the
modules image also(but that was a second question)

did dpkg -i linux-image*

updated grub and placed files in /boot, but did not create initrd image.
Why is that?

Thanks

Balaji R
