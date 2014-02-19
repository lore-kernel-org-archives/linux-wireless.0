Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55590 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaBSJs0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 04:48:26 -0500
Message-ID: <1392803291.4733.8.camel@jlt4.sipsolutions.net> (sfid-20140219_104831_669067_75598BD1)
Subject: Re: [PATCH] ath9k: Enable U-APSD AP mode support
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 19 Feb 2014 10:48:11 +0100
In-Reply-To: <5303DC33.5050105@openwrt.org>
References: <20140218184108.GA24197@jouni.qca.qualcomm.com>
		 (sfid-20140218_194116_149252_F9CC32B2) <1392750354.5438.8.camel@jlt4.sipsolutions.net>
	 <5303DC33.5050105@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-18 at 23:18 +0100, Felix Fietkau wrote:
> On 2014-02-18 20:05, Johannes Berg wrote:
> > On Tue, 2014-02-18 at 20:41 +0200, Jouni Malinen wrote:
> >> mac80211 handles the actual operations, so ath9k can just indicate
> >> support for this. Based on initial tests, this combination seems to
> >> work fine.
> > 
> > I believe this is not true with aggregation sessions.
> Why not? Block Ack Window handling is handled by
> .release_buffered_frames just fine (and tested with PS-Poll).

Yeah, n/m, I missed that you implemented that.

johannes

