Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58512 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756620AbYJVT1K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 15:27:10 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 12:27:10 -0700
Date: Wed, 22 Oct 2008 05:27:04 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] wireless: add regulatory_struct_hint
Message-ID: <20081022122704.GG6190@tesla> (sfid-20081022_212721_258341_BA5CDDA5)
References: <1224585110.5521.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1224585110.5521.8.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2008 at 03:31:50AM -0700, Johannes Berg wrote:
> +extern void regulatory_struct_hint(struct ieee80211_regdomain *rd,
> +                                  u32 bands);
>  #endif /* __NET_WIRELESS_H */
> --- everything.orig/net/wireless/reg.c  2008-10-21 11:50:14.000000000 +0200
> +++ everything/net/wireless/reg.c       2008-10-21 12:26:08.000000000 +0200
>  EXPORT_SYMBOL(regulatory_hint);
> 
> +void regulatory_struct_hint(struct ieee80211_regdomain *rd, u32 bands)
> +{

<-- snip -->

> +}
> +

Oh and forgot the EXPORT_SYMBOL(regulatory_struct_hint) though.

  Luis
