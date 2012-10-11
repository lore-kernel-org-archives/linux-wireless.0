Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49077 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab2JKHsu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 03:48:50 -0400
Message-ID: <1349941762.13097.0.camel@jlt4.sipsolutions.net> (sfid-20121011_094853_113035_75B36E7E)
Subject: Re: [PATCH v2] {nl,cfg}80211: Peer STA VHT caps
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"j@w1.fi" <j@w1.fi>
Date: Thu, 11 Oct 2012 09:49:22 +0200
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCFB4B0@mbx022-e1-nj-10.exch022.domain.local>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCFB4B0@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-10-11 at 05:44 +0000, Mahesh Palivela wrote:
> From: Mahesh Palivela <maheshp@posedge.com>
> 
> To save STAs VHT caps in AP mode
> 
> Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
> ---
> Patch version 2 to take care of Jouni Malinen's comment
> 
>  include/linux/nl80211.h |    3 +++
>  include/net/cfg80211.h  |    2 ++
>  net/mac80211/cfg.c      |    5 +++++
>  net/wireless/nl80211.c  |    5 +++++
>  4 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index 179a0c2..b82ab80 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -1535,6 +1535,8 @@ enum nl80211_attrs {
>  
>  	NL80211_ATTR_SAE_DATA,
>  
> +	NL80211_ATTR_VHT_CAPABILITY,

Looks fine, but please add documentation for this new attribute.

johannes

