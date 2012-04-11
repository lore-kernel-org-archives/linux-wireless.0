Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53143 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759972Ab2DKLpI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 07:45:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SHvyz-0007GF-QS
	for linux-wireless@vger.kernel.org; Wed, 11 Apr 2012 13:45:05 +0200
Received: from 83.137.242.22 ([83.137.242.22])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 13:45:05 +0200
Received: from hamelg by 83.137.242.22 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 13:45:05 +0200
To: linux-wireless@vger.kernel.org
From: hamelg <hamelg@laposte.net>
Subject: Re: ath5k phy0: gain calibration timeout
Date: Wed, 11 Apr 2012 11:39:37 +0000 (UTC)
Message-ID: <loom.20120411T132832-46@post.gmane.org> (sfid-20120411_134519_950633_E8055A5E)
References: <20120227031232.GA1190@spacedout.fries.net> <4F4B71F2.1020709@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@...> writes:

> 
> On 2012-02-27 4:12 AM, David Fries wrote:
> > Wireless network stopped working after 22 hours with ath5k, I have the
> > following message repeating, suspending to ram and back was enough to
> > get it talking again.
> > ath5k phy0: gain calibration timeout (2462MHz)
> > 
> > I revered the following two comments and will see if I run into any
> > more problems.  I can test patches.
> > ath5k: We always do full calibration on AR5210
> > dafae6af0336958e9e2eb67cc5e4e31d6d13b308
> > ath5k: Calibration re-work
> > ce169aca0d823d38465127023e3d571816e6666c
> Please try applying the following two patches:
>
http://nbd.name/gitweb.cgi?p=openwrt.git;a=blob_plain;f=package/mac80211/patches/440-ath5k_calibrate_no_queue_stop.patch;hb=HEAD
>
http://nbd.name/gitweb.cgi?p=openwrt.git;a=blob_plain;f=package/mac80211/patches/441-ath5k_no_agc_recalibration.patch;hb=HEAD

Hello,
archlinux users are affected by this issue after upgrading the linux kernel in
3.3.1 :
https://bbs.archlinux.org/viewtopic.php?id=139270
Do you known if these two patches have been merged in the mainstream branch ?
thank you

