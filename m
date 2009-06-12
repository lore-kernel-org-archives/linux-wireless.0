Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost03.isp.att.net ([207.115.11.53]:49982 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbZFLXfe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 19:35:34 -0400
Message-ID: <4A32E645.1040002@lwfinger.net>
Date: Fri, 12 Jun 2009 18:35:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Fabio A. Correa" <facorread@gmail.com>
CC: bcm43xx-dev@lists.berlios.de,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: 4311 not detected at all
References: <ec2083b20906120654j370e5bdo724a7c3b6d505a6c@mail.gmail.com>	 <4A326771.6030301@lwfinger.net> <ec2083b20906120759x4a8c247eh61d1f6bdb6f194f6@mail.gmail.com>
In-Reply-To: <ec2083b20906120759x4a8c247eh61d1f6bdb6f194f6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fabio A. Correa wrote:
> Hey, I found an updated BIOS available in the HP site, obviously
> requiring Windows. I had deleted those partitions, so I will get a
> Windows hard disk/CD and try to flash it. I did not work under Wine...
> I will keep you informed.

If you have access to a running Windows XP system on another computer,
there is a way to build a Windows Live CD from which to run your BIOS
update. Download the Bart's PE file (http://www.nu2.nu/pebuilder/) and
install it. Run it with a Windows distribution CD mounted.

If you have the Windows CD, but not access to a machine running
Windows, the .iso can be built in a virtual machine. I used a
VirtualBox copy of Windows XP. Unfortunately, the builder will not run
in Wine.


Larry
