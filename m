Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51563 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab3E0ImY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 04:42:24 -0400
Message-ID: <1369644140.8229.4.camel@jlt4.sipsolutions.net> (sfid-20130527_104228_089081_C774CB16)
Subject: Re: [PATCH 1/3] cfg80211: support an active monitor interface flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 May 2013 10:42:20 +0200
In-Reply-To: <1369577107-87931-1-git-send-email-nbd@openwrt.org>
References: <1369577107-87931-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-05-26 at 16:05 +0200, Felix Fietkau wrote:
> An active monitor interface is one that is used for communication (via
> injection). It is expected to ACK incoming unicast packets. This is
> useful for running various 802.11 testing utilities that associate to an
> AP via injection and manage the state in user space.

I think it would be useful to make an nl80211 feature flag for this.

johannes

