Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50201 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbaBRWSx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 17:18:53 -0500
Message-ID: <5303DC33.5050105@openwrt.org> (sfid-20140218_231856_611577_7DE2DE8C)
Date: Tue, 18 Feb 2014 23:18:27 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <jouni@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Enable U-APSD AP mode support
References: <20140218184108.GA24197@jouni.qca.qualcomm.com>	 (sfid-20140218_194116_149252_F9CC32B2) <1392750354.5438.8.camel@jlt4.sipsolutions.net>
In-Reply-To: <1392750354.5438.8.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-02-18 20:05, Johannes Berg wrote:
> On Tue, 2014-02-18 at 20:41 +0200, Jouni Malinen wrote:
>> mac80211 handles the actual operations, so ath9k can just indicate
>> support for this. Based on initial tests, this combination seems to
>> work fine.
> 
> I believe this is not true with aggregation sessions.
Why not? Block Ack Window handling is handled by
.release_buffered_frames just fine (and tested with PS-Poll).

- Felix

