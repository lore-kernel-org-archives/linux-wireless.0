Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from SpacedOut.fries.net ([67.64.210.234]:49686 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2CJS5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 13:57:04 -0500
Date: Sat, 10 Mar 2012 12:56:50 -0600
From: David Fries <david@fries.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: ath5k phy0: gain calibration timeout
Message-ID: <20120310185649.GC1190@spacedout.fries.net> (sfid-20120310_195709_003315_4D6303CC)
References: <20120227031232.GA1190@spacedout.fries.net>
 <4F4B71F2.1020709@openwrt.org>
 <20120227144255.GB1190@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120227144255.GB1190@spacedout.fries.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 27, 2012 at 08:42:55AM -0600, David Fries wrote:
> On Mon, Feb 27, 2012 at 01:07:14PM +0100, Felix Fietkau wrote:
> > On 2012-02-27 4:12 AM, David Fries wrote:
> > > Wireless network stopped working after 22 hours with ath5k, I have the
> > > following message repeating, suspending to ram and back was enough to
> > > get it talking again.
> > > ath5k phy0: gain calibration timeout (2462MHz)
> > > 
> > Please try applying the following two patches:
> > http://nbd.name/gitweb.cgi?p=openwrt.git;a=blob_plain;f=package/mac80211/patches/440-ath5k_calibrate_no_queue_stop.patch;hb=HEAD
> > http://nbd.name/gitweb.cgi?p=openwrt.git;a=blob_plain;f=package/mac80211/patches/441-ath5k_no_agc_recalibration.patch;hb=HEAD

No problems running with the above two patches after 12 days.  No
calibration timeout messages either.  Thanks.

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
