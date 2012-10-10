Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:45083 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755199Ab2JJVwo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 17:52:44 -0400
Date: Thu, 11 Oct 2012 00:52:35 +0300
From: Jouni Malinen <j@w1.fi>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] {nl,cfg}80211: peer STA VHT caps
Message-ID: <20121010215235.GB18956@w1.fi> (sfid-20121010_235247_478992_777F1987)
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCFB3C5@mbx022-e1-nj-10.exch022.domain.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCFB3C5@mbx022-e1-nj-10.exch022.domain.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 10, 2012 at 05:55:42PM +0000, Mahesh Palivela wrote:
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> @@ -1324,6 +1324,7 @@ enum nl80211_attrs {
>  	NL80211_ATTR_BSS_SHORT_SLOT_TIME,
>  
>  	NL80211_ATTR_HT_CAPABILITY,
> +	NL80211_ATTR_VHT_CAPABILITY,
>  
>  	NL80211_ATTR_SUPPORTED_IFTYPES,

NACK - please see the comment at the end of the enum about the place
where to add new attributes in a way that does not break compatibility
with existing user space..

-- 
Jouni Malinen                                            PGP id EFC895FA
