Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44756 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab3GPOs7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 10:48:59 -0400
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 3.11] mac80211/minstrel: fix NULL pointer dereference  issue
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 16 Jul 2013 17:48:56 +0300
From: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, krzysiek@podlesie.net
In-Reply-To: <1373891706-1071-1-git-send-email-nbd@openwrt.org>
References: <1373891706-1071-1-git-send-email-nbd@openwrt.org>
Message-ID: <692afa2182af4dae43c3298775038b02@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-07-15 15:35, Felix Fietkau wrote:
> When priv_sta == NULL, mi->prev_sample is dereferenced too early. Move
> the assignment further down, after the rate_control_send_low call.

Applied.

johannes
