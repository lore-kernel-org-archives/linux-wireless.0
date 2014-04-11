Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50736 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbaDKHiU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2014 03:38:20 -0400
Message-ID: <1397201882.4420.3.camel@jlt4.sipsolutions.net> (sfid-20140411_093823_576932_DAEA5B2D)
Subject: Re: [PATCH 3.15] mac80211: exclude AP_VLAN interfaces from tx power
 calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 11 Apr 2014 09:38:02 +0200
In-Reply-To: <1397135208-14828-1-git-send-email-nbd@openwrt.org>
References: <1397135208-14828-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-04-10 at 15:06 +0200, Felix Fietkau wrote:
> Their power value is initialized to zero. This patch fixes an issue
> where the configured power drops to the minimum value when AP_VLAN
> interfaces are created/removed.

Applied.

johannes

