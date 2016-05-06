Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm3-vm4.bullet.mail.ir2.yahoo.com ([212.82.96.93]:46856 "EHLO
	nm3-vm4.bullet.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306AbcEFKkJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2016 06:40:09 -0400
Date: Fri, 6 May 2016 10:33:47 +0000 (UTC)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: Hin-Tak Leung <htl10@users.sourceforge.net>
To: <federicoleva@tiscali.it>, <linux-wireless@vger.kernel.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
	Herton Ronaldo Krzesinski <herton@canonical.com>
Message-ID: <1642913259.764262.1462530827201.JavaMail.yahoo@mail.yahoo.com> (sfid-20160506_124015_355966_1C129A8A)
Subject: Re: Realtek RTL8723BE wireless card drops connection
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1642913259.764262.1462530827201.JavaMail.yahoo.ref@mail.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The MAINTAINERS file did mention that the appropriate mailing list to use is
the linux-wireless one. Using an appropriate list is preferable to e-mailing individuals. Added in the TO:.

That card uses the rtlwifi module, so that seems to be Larry's and Chaoming's to look at.

--------------------------------------------
On Fri, 6/5/16, Federico Leva <federicoleva@tiscali.it> wrote:
 
 Hello,
 I see in 
 
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/MAINTAINERS

 
 that you maintain some RTL8* wireless driver. Sorry for the
 direct 
 emaill, but did you see the report 
 https://marc.info/?l=linux-wireless&m=143420832618489&w=2
 and is 
 anything else needed?
 
 There are hundreds of bug reports about this card on
 launchpad alone 
 (apparently it's shipped by HP, Lenovo and others with many
 laptops), 
 but the bug is still present: I've verified it in Fedora 23
 and Ubuntu 
 16.04 (Linux 4.4.0-21) and others found it in Linux 4.5.
 
 Example bug reports with useful information in launchpad for
 Ubuntu:
 * https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1459367
 * https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1461174
 * https://bugs.launchpad.net/hwe-next/+bug/1461174
 
 Thanks,
     Federico
