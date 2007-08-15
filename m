Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:42379 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbXHODoN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 23:44:13 -0400
Date: Tue, 14 Aug 2007 20:43:12 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] hostapd: remove use of ieee80211_msg_key_threshold_notification
Message-ID: <20070815034312.GK1415@jm.kir.nu>
References: <1186782285.17351.19.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1186782285.17351.19.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 10, 2007 at 11:44:45PM +0200, Johannes Berg wrote:
> The code is #if 0'ed anyway, so might as well not use the constant.

Just like ieee80211_msg_sta_not_assoc, this one is a useful notification
and I would rather not see it being removed. Consequently, I did not
apply this. I would be much more open to changing this notification to
use some other mechanism if there is a reason to get rid of
ieee80211_msg_* types, but just removing this because the code is
currently #if 0'ed in hostapd is not a reason I would support.

-- 
Jouni Malinen                                            PGP id EFC895FA
