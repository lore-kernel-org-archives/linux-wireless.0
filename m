Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:35892 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab3BFX42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 18:56:28 -0500
Message-ID: <5112EDAA.9050002@lwfinger.net> (sfid-20130207_005636_018450_D2651CC8)
Date: Wed, 06 Feb 2013 17:56:26 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Thomas Rosenkranz <tom.rosary@googlemail.com>
CC: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-usb@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: bugreport upstream: 0bda:819a RTL8188CUS WLAN doesn't work out
 of the box
References: <51045387.2040607@gmail.com> <5112A972.3060109@lwfinger.net> <CAOAX8-np_cY85=qL4TQCS9_d3tvggZTww7Maq1RWcasJsQxngw@mail.gmail.com>
In-Reply-To: <CAOAX8-np_cY85=qL4TQCS9_d3tvggZTww7Maq1RWcasJsQxngw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2013 02:03 PM, Thomas Rosenkranz wrote:
> Sorry for aksing back.
> 1. You mean I should get the kernel clean of the realtek driver first
> to prevent a crash during patching? Cause unplugging is no option for
> a onboard device.
> 2. I have no idea what to do with the patching file and couldn't find
> any good instructions with google. "man patch" doesn't make me smarter
> at all

Put the patch in the directory where the arch, block, crypto, drivers, and so 
forth directories are located. Then run the command

patch -p1 < 0001-......patch

After that, run "make" followed by "sudo make modules_install install". If your 
distro is reasonable, that will give you a new entry in your boot menu.

Larry


