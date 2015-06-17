Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46868 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbbFQJEJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 05:04:09 -0400
Message-ID: <1434531847.1884.21.camel@sipsolutions.net> (sfid-20150617_110413_158399_50BF0B7B)
Subject: Re: [PATCH] mac80211: process the target only subfield for mesh
 hwmp accordingly
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 17 Jun 2015 11:04:07 +0200
In-Reply-To: <1434340733-10972-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20150615_055946_622067_FCBDE8B0)
References: <1434340733-10972-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20150615_055946_622067_FCBDE8B0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-06-15 at 11:58 +0800, Chun-Yeow Yeoh wrote:
> This patch does the following:
> - Remove unnecessary flags field used by PERR element.
> - Use the per target flags defined in ./include/linux/ieee80211.h.
> - Process the target only subfield based on case E2 of sec 13.10.9.3
>   of IEEE 802.11-2012.

Applied.

johannes

