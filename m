Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:46394 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab2DBTn0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 15:43:26 -0400
Received: from ipb1.telenor.se (ipb1.telenor.se [195.54.127.164])
	by smtprelay-b22.telenor.se (Postfix) with ESMTP id 34DD714006
	for <linux-wireless@vger.kernel.org>; Mon,  2 Apr 2012 21:23:38 +0200 (CEST)
Message-ID: <1333394617.2725.11.camel@tux.homenetwork> (sfid-20120402_214329_483716_933996F1)
Subject: Re: carl9170 driver - network connection breaks
From: Per-Erik Westerberg <per-erik.westerberg@bredband.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 02 Apr 2012 21:23:37 +0200
In-Reply-To: <4f79e539d908b3.59415590@wp.pl>
References: <4f79e539d908b3.59415590@wp.pl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mån 2012-04-02 klockan 19:43 +0200 skrev Mikołaj Kuligowski:
> carl9170 driver - network connection "hangs". It happens if some bigger file is being downloaded (few MB or bigger). It doesn't happen on kernels less then 3.2 (works well with 3.1 and previous) and doesn't depend on firmware - it happens with all available firmware versions: 1.9.3, 1.9.4, 1.9.5.  I use USB wireless card TP-LINK TL-WN821N. Ubuntu 12.04. The device works perfect with Oneiric, breaks with Precise. Please help.
> 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/971728
> 
> __________________

Hi,

I am seeing exactly the same issues using an Netgear WNDA3100 when using
anything newer that 3.1 kernel with the carl9170 driver and the firmware
from http://linuxwireless.org/.

I am using Gentoo Linux and have tried using both the gentoo-sources
3.3.0, the vanilla kernel 3.3.0 and the git-sources (3.3-rc7). I have
not yet tried 3.4-rc1 but will try that also.

I have tried to enable debugfs and all the debugging options that I can
find in the kernel-config and have googled for information on how to
actually use debugfs but have failed to understand how to use it, any
ideas on what to look for?

  BR / P-E

