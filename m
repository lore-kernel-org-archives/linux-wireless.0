Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54256 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaBLK04 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 05:26:56 -0500
Message-ID: <1392200810.4146.2.camel@jlt4.sipsolutions.net> (sfid-20140212_112713_177694_B8931104)
Subject: Re: [PATCH v2 3.14] mac80211: send control port protocol frames to
 the VO queue
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 12 Feb 2014 11:26:50 +0100
In-Reply-To: <1392130967-9624-1-git-send-email-nbd@openwrt.org>
References: <1392130967-9624-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-11 at 16:02 +0100, Felix Fietkau wrote:
> Improves reliability of wifi connections with WPA, since authentication
> frames are prioritized over normal traffic and also typically exempt
> from aggregation.

Applied.

johannes

