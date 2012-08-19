Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.multi.fi ([85.134.37.151]:51619 "EHLO smtp.multi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab2HSLk4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2012 07:40:56 -0400
Message-ID: <5030CD6D.9010002@mageia.org> (sfid-20120819_134059_651851_A4332495)
Date: Sun, 19 Aug 2012 14:26:37 +0300
From: Thomas Backlund <tmb@mageia.org>
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net
CC: linux-wireless@vger.kernel.org
Subject: Re: Missing firmware iwlwifi-2030-5.ucode
References: <502D0C72.2050207@lwfinger.net>
In-Reply-To: <502D0C72.2050207@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

16.08.2012 18:06, Larry Finger skrev:
> Hi,
>
> I am trying to help an openSUSE 12.1 user who is running kernel 3.1.9,
> who has an Intel 802.11 b/g/n card with Bluetooth mounted in an HP
> dvdt-7000 Quad Edition Series computer.
>
> The driver is asking for firmware named "iwlwifi-2030-5.ucode"; however,
> that particular file does not exist in /lib/firmware, nor is in the
> linux-firmware git repo where only the version 6 firmware exists.
>
> I could find no record of the firmware ever being in the git repo, nor
> could I find it using a Google search. For users of kernel 3.1, I
> request that this firmware file be submitted to linux-firmware. In
> addition, if you send me a copy of the file, I will see that the OP on
> the openSUSE Forum gets a copy.
>

You need atleast:
http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commitdiff;h=37273f55830f0919d543250d191e1633ff53841c


If this is a distro kernel, you probably need theese too:

http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commitdiff;h=13cb8e3a067538c5aacc846a032985d2b608bccd
http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commitdiff;h=20d6f19dca576a671ab61403c366c7154f802b36
http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commitdiff;h=9e8ed57850a9d5157430fb09161a2456171d8684

--
Thomas

