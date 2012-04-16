Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:58912 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab2DPJOG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 05:14:06 -0400
Message-ID: <4F8BE25B.5030208@01019freenet.de> (sfid-20120416_111413_162608_0A68AD7E)
Date: Mon, 16 Apr 2012 11:11:55 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Jakub Kicinski <kubakici@wp.pl>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 0/4] rt2x00: fix initialization after legacy
 driver
References: <1332859867-27921-1-git-send-email-kubakici@wp.pl>
In-Reply-To: <1332859867-27921-1-git-send-email-kubakici@wp.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jakub,

Jakub Kicinski wrote:
> Hi,
> 
> I've been testing these patches for a few weeks and I think it's about 
> the time to post them.
> 
> The main purpose of this set is to make it possible to switch between
> rt2800pci and legacy driver w/o rebooting or suspending whole machine.
> Today rt2800pci will fail to bring the interface up if it was earlier
> operated by legacy drv. I'm sure it happens with rt3090, rt2860 seems
> to work fine.

I'm running these patches since a few weeks now. I didn't had the
problem you tried to fix (because I never used the legacy driver), but I
had another one, which seems to be fixed with this patchset, too:

Before this set, the device often wasn't usable at all after loading the
modules and starting of hostapd. No beacon could be seen, although the
log files didn't show any problem.

With your patchset applied, I face this problem really seldom now, about
once a week (instead of 3 or 4 times a day).


Thanks!
Regards,
Andreas
