Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2747 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754803AbYGNTIf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 15:08:35 -0400
Date: Mon, 14 Jul 2008 14:49:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh
	beacons
Message-ID: <20080714184928.GA10328@tuxdriver.com> (sfid-20080714_210839_445272_B32D98C0)
References: <200807091511.14288.IvDoorn@gmail.com> <200807091511.45779.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200807091511.45779.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 09, 2008 at 03:11:45PM +0200, Ivo van Doorn wrote:
> Currently only beacons generated in AP mode have the software
> sequence number inserted. This means IBSS and Mesh mode are broken
> for all hardware that require software sequence numbers.
> 
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

As you are aware, Johannes posted a patch that removed
ieee80211_include_sequence.  I'm dropping this (i.e. Ivo's) patch.

John
-- 
John W. Linville
linville@tuxdriver.com
