Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43803 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3CTVCM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 17:02:12 -0400
Message-ID: <1363813329.9284.6.camel@jlt4.sipsolutions.net> (sfid-20130320_220215_549451_40356E3A)
Subject: Re: [PATCH 2/4] mac80211: use ieee80211_p2p_noa_attr structure
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 20 Mar 2013 22:02:09 +0100
In-Reply-To: <CAFED-jk3UYwxD52mWOQA_DRfzz3Sv90To6sQ9A5R2Ni+dX4w7Q@mail.gmail.com> (sfid-20130320_201357_557654_E73E8A7A)
References: <CAFED-jk3UYwxD52mWOQA_DRfzz3Sv90To6sQ9A5R2Ni+dX4w7Q@mail.gmail.com>
	 (sfid-20130320_201357_557654_E73E8A7A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-03-20 at 20:13 +0100, Janusz Dziedzic wrote:
> Use ieee80211_p2p_noa_attr structure during
> P2P_PS (oppps) detection.
> 
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---
>  net/mac80211/mlme.c |   26 +++++++++++++++-----------
>  1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index fdc06e3..14612cd 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1655,18 +1655,20 @@ static void ieee80211_set_associated(struct
> ieee80211_sub_if_data *sdata,

This is line-break damage, the patch doesn't apply.

johannes

