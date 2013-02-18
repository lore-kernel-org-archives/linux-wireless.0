Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42466 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3BRLqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 06:46:05 -0500
Message-ID: <1361187960.8555.9.camel@jlt4.sipsolutions.net> (sfid-20130218_124610_221595_1DCC6673)
Subject: Re: patch : mac80211:Multicast patch for linux-2.6.28.1 (wl12xx
 drivers)
From: Johannes Berg <johannes@sipsolutions.net>
To: Girish Bn <Girish.BN@lnties.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 18 Feb 2013 12:46:00 +0100
In-Reply-To: <45566970CF58C74CB52107862E0541CD1D1F72BC@POCITMSEXMB02.LntUniverse.com>
References: <45566970CF58C74CB52107862E0541CD1D1F72A2@POCITMSEXMB02.LntUniverse.com>
	 (sfid-20130218_120856_334947_2BD0FBB7) <1361185913.8555.6.camel@jlt4.sipsolutions.net>
	 (sfid-20130218_121202_160075_39158588) <1361185996.8555.7.camel@jlt4.sipsolutions.net>
	 <45566970CF58C74CB52107862E0541CD1D1F72BC@POCITMSEXMB02.LntUniverse.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-18 at 11:25 +0000, Girish Bn wrote:
> Hi,

(please don't top-post)

> This particular change is required on for the multicast to work
> successfully on Linux kernel 2.6.28.2. I thought through this forum I
> can make others to use this patch to resolve multicast issue. I accept
> that I am new to open source. If any proper way to make multicast to
> work, please suggest otherwise discard the patch. For me this patch is
> working to receive IGMP packets over the Wireless network

This particular patch is not required upstream because upstream has long
moved past 2.6.28(.2). If you need this included in TI's special compat
version you need to talk to them.

In any case, I cannot and will not apply patches to any tree that carry
a "confidential information" footer and/or don't have a sign-off.

johannes

