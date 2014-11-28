Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41428 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbaK1OCm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 09:02:42 -0500
Message-ID: <1417183359.27562.13.camel@sipsolutions.net> (sfid-20141128_150245_917900_5D0C88F0)
Subject: Re: [PATCH v2 1/7] mac80211: minstrel_ht: move aggregation check to
 .get_rate()
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Nov 2014 15:02:39 +0100
In-Reply-To: <1416424093-19439-1-git-send-email-nbd@openwrt.org>
References: <1416424093-19439-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-11-19 at 20:08 +0100, Felix Fietkau wrote:
> Preparation for adding a no-skb tx status path

Looks fine, applied all 7.

johannes

