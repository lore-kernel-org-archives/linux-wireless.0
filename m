Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:33679 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbXHREKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Aug 2007 00:10:51 -0400
Date: Fri, 17 Aug 2007 21:09:43 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 08/20] mac80211: remove unused ioctls (3)
Message-ID: <20070818040943.GH1415@jm.kir.nu>
References: <20070815144920.135826000@sipsolutions.net> <20070815145045.151670000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070815145045.151670000@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 15, 2007 at 04:49:28PM +0200, Johannes Berg wrote:
> The ioctls
> 
>  * PRISM2_PARAM_HW_MODES
>  * PRISM2_PARAM_CREATE_IBSS
>  * PRISM2_PARAM_WMM_ENABLED
>  * PRISM2_PARAM_MIXED_CELL
>  * PRISM2_PARAM_KEY_MGMT
> 
> are not used by hostapd or wpa_supplicant.

No, but iwpriv.. See the pattern here.. ;-)

Create IBSS is a somewhat commonly used configuration and so is mixed
cell configuration in Cisco-world (and the only point for the
privacy_mismatch check that is left broken after this patch).

-- 
Jouni Malinen                                            PGP id EFC895FA
