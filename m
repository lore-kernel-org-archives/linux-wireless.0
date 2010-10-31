Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48049 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab0JaPRC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Oct 2010 11:17:02 -0400
Subject: Re: [PATCH] cfg80211: fix a crash in dev lookup on dump commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4CCD7DDA.3050806@openwrt.org>
References: <4CCD7DDA.3050806@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 31 Oct 2010 16:17:00 +0100
Message-ID: <1288538220.3839.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-10-31 at 15:31 +0100, Felix Fietkau wrote:
> IS_ERR and PTR_ERR were called with the wrong pointer, leading to a
> crash when cfg80211_get_dev_from_ifindex fails.

Good catch, thanks.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

