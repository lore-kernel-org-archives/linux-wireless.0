Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab2A3Oz2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 09:55:28 -0500
Subject: Re: status of ipw2x00
From: Johannes Berg <johannes@sipsolutions.net>
To: Tom Gundersen <teg@jklm.no>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	linux-wireless@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <CAG-2HqUqwHo_xgqC79riQF2DA4DPz1Qy5ZARQK8GT+tf_-UKRg@mail.gmail.com> (sfid-20120130_144316_998822_69311B85)
References: <CAG-2HqUqwHo_xgqC79riQF2DA4DPz1Qy5ZARQK8GT+tf_-UKRg@mail.gmail.com>
	 (sfid-20120130_144316_998822_69311B85)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Jan 2012 06:55:23 -0800
Message-ID: <1327935323.3630.3.camel@jlt3.sipsolutions.net> (sfid-20120130_155536_052581_AB6CEF59)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-01-30 at 14:42 +0100, Tom Gundersen wrote:

> I'm the udev maintainer for Arch Linux, and we have been running into
> some problems with the ipw2200 driver[0]. This was most probably
> exposed by changes in recent versions of udev, as outlined here [1]
> (so will eventually hit the other distros when they upgrade).
> 
> I see that the ipw2x00 drivers are listed as Orphaned in MANTAINERS,
> and I notice that 2000-series Wireless-N support was added to iwlagn.
> 
> Does this mean that we (as a dristro) should drop the ipw2x00 driver
> in favor of iwlagn, or do they actualy support different hardware? I
> was not able to find any reference to 2000-series Wireless-N chips on
> intel.com, so I'm not really sure what hardware this "Intel(R)
> Centrino(R) Wireless-N 2200D BGN" is referring to (if it is not [2].
> Furthermore, I noticed that the modaliases of the two drivers do not
> overlap, which should indicate that they do not support the same
> hardware, is that correct?

Yes, it's unfortunate but true -- ipw 2200 and the current 2200 devices
are completely different hardware, there's no overlap.

johannes

