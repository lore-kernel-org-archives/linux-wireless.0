Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45309 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab2JJKxR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 06:53:17 -0400
Message-ID: <1349866434.4683.49.camel@jlt4.sipsolutions.net> (sfid-20121010_125322_042562_36CD9548)
Subject: Re: [PATCH v4 1/2] mac80211: VHT peer STA caps
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 10 Oct 2012 12:53:54 +0200
In-Reply-To: <506BBF62.4080906@posedge.com>
References: <506BBF62.4080906@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-03 at 10:00 +0530, Mahesh Palivela wrote:
> From: Mahesh Palivela <maheshp@posedge.com>
> 
> Rename vht_capabilities to vht_cap
> 
> Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
> ---
> 
>   include/linux/ieee80211.h |    2 +-
>   net/mac80211/main.c       |    2 +-
>   net/mac80211/mlme.c       |    4 ++--
>   net/mac80211/util.c       |    4 ++--
>   4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index 2385119..afd12d9 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -1109,7 +1109,7 @@ struct ieee80211_ht_operation {
> 
>   #define VHT_MCS_SUPPORTED_SET_SIZE      8
> 
> -struct ieee80211_vht_capabilities {
> +struct ieee80211_vht_cap {
>   	__le32 vht_capabilities_info;
>   	u8 vht_supported_mcs_set[VHT_MCS_SUPPORTED_SET_SIZE];
>   } __packed;

This patch doesn't rename any fields

johannes

