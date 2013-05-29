Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59890 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933784Ab3E2HLT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 03:11:19 -0400
Message-ID: <1369811476.8414.2.camel@jlt4.sipsolutions.net> (sfid-20130529_091122_025542_269888A8)
Subject: Re: [PATCH] cfg80211: fix a crash in the active monitor check
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 May 2013 09:11:16 +0200
In-Reply-To: <1369776014-10148-1-git-send-email-nbd@openwrt.org>
References: <1369776014-10148-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-05-28 at 23:20 +0200, Felix Fietkau wrote:
> flags can be NULL

I merged this into the original patch and also fixed the kernel-doc for
you while at it.

johannes

