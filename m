Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4340 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537AbXKNPJF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 10:09:05 -0500
Date: Wed, 14 Nov 2007 10:08:39 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Henning Rogge <rogge@fgan.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Virtual wireless network card for mac80211
Message-ID: <20071114150839.GA6226@tuxdriver.com> (sfid-20071114_150909_422701_3EF1A531)
References: <200711141316.50393.rogge@fgan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200711141316.50393.rogge@fgan.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 14, 2007 at 01:16:50PM +0100, Henning Rogge wrote:

> I'm looking for a way to simulate a ieee802.11 card on a linux system. Is 
> there an equivalent for tun/tap for the mac80211 layer, so I can just send 
> the communication with a wireless device back to userspace (and data from 
> userspace into the wireless stack) ?

No, but I have been thinking about this as well.  It might be a nice
capability to have, so long as the regulatory spectre continues to
discourage some vendors from disclosing information about their
hardware.  At least such a scenario seems less grey w.r.t. GPL
compliance.

Still, I would not want to put much effort into a project that
distracts from development of fully open source drivers.  But I think
the performance of such a solution would be sub-optimal enough to
discourage full reliance upon it.  And the plus of having a userland
binary driver versus no driver at all might make it worthwhile.

What is the situation that makes this interesting to you?

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
