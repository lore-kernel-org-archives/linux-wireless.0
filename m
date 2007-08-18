Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:50212 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbXHREId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Aug 2007 00:08:33 -0400
Date: Fri, 17 Aug 2007 21:07:25 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 07/20] mac80211: remove unused ioctls (2)
Message-ID: <20070818040725.GG1415@jm.kir.nu>
References: <20070815144920.135826000@sipsolutions.net> <20070815145044.386019000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070815145044.386019000@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 15, 2007 at 04:49:27PM +0200, Johannes Berg wrote:
> The ioctls
> 
>  * PRISM2_PARAM_STA_ANTENNA_SEL
>  * PRISM2_PARAM_TX_POWER_REDUCTION
>  * PRISM2_PARAM_KEY_INDEX
>  * PRISM2_PARAM_DEFAULT_WEP_ONLY
>  * PRISM2_PARAM_ALLOW_BROADCAST_ALWAYS
> 
> are not used by hostapd or wpa_supplicant.

Well, maybe so. But again, some are useful for testing (e.g., allow
broadcast always for continuous TX tests). Default WEP only is useful
for optimizing hwaccel in some multi-SSID cases, but it seemed to have
already been broken before..

-- 
Jouni Malinen                                            PGP id EFC895FA
