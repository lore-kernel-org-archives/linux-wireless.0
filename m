Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59119 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbcBWKCf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 05:02:35 -0500
Message-ID: <1456221753.2041.4.camel@sipsolutions.net> (sfid-20160223_110242_960413_6D122E6B)
Subject: Re: [PATCH] cfg80211: reuse existing page fragments in A-MSDU rx
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Date: Tue, 23 Feb 2016 11:02:33 +0100
In-Reply-To: <1454938482-81027-1-git-send-email-nbd@openwrt.org>
References: <1454938482-81027-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-02-08 at 14:34 +0100, Felix Fietkau wrote:
> This massively reduces data copying and thus improves rx performance
> 
Applied.

johannes
