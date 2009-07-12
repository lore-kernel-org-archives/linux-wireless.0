Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:53650 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbZGLPRf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2009 11:17:35 -0400
Received: by fxm18 with SMTP id 18so1753666fxm.37
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2009 08:17:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090712105807.g85wo8lpgk04k8gk-cebfxv@webmail.spamcop.net>
References: <fbad4e140907081555w3a98c570y54d904272094008@mail.gmail.com>
	 <4A577DA9.9000205@gmail.com> <4A57DC26.4090708@gmail.com>
	 <4A58FC5C.8060204@gmail.com>
	 <20090712105807.g85wo8lpgk04k8gk-cebfxv@webmail.spamcop.net>
Date: Sun, 12 Jul 2009 16:09:25 +0100
Message-ID: <fbad4e140907120809o53947ca2y87406fc367ff7119@mail.gmail.com>
Subject: Re: [Orinoco-devel] orinoco-usb in 2.6.31?
From: David Gerard <dgerard@gmail.com>
To: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/7/12 Pavel Roskin <proski@gnu.org>:

> I have an impression that orinoco-usb should be submitted to the staging
> tree.  Perhaps its symbols should be renamed to allow it to coexist with the
> plain orinoco driver, even if both are linked into the kernel.
> I was hoping that we would reorganize the orinoco driver to allow
> orinoco-usb to be one of its frontends, but it's not happening.  All the
> efforts that go into orinoco-usb is keeping it up-to-date with the kernel.


It's unspeakably horrible and only us old W200 owners are keeping
interest up. I've probably posted this here before, but even the
Windows driver doesn't work properly:

http://forums11.itrc.hp.com/service/forums/bizsupport/questionanswer.do?admit=109447626+1247092556853+28353475&threadId=1072085

If you use the latest driver, 1.00F, on XP, it blue-screens if it even
*sees* an 802.11n access point in range! You have to downgrade to
1.00C, so no WPA on Windows either.

It wouldn't take much to make the Linux driver better, even as is :-)
All it needs now is redistributable firmware.


- d.
