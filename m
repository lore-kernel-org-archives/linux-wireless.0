Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:34944 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaAGOQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 09:16:36 -0500
Received: by mail-wg0-f45.google.com with SMTP id y10so196591wgg.0
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jan 2014 06:16:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389092979-11957-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1389092979-11957-1-git-send-email-emmanuel.grumbach@intel.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 7 Jan 2014 19:46:14 +0530
Message-ID: <CABPxzY+u5VTX1RdPf7XVadMLv5xZgXeaz_VcD3T4FLEtupgUDQ@mail.gmail.com> (sfid-20140107_151639_789174_D8B0E232)
Subject: Re: [PATCH 1/2] mac80211: clean up garbage in comment
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 7, 2014 at 4:39 PM, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
>
> Not clear how this landed here.
>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  net/mac80211/wpa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
> index 0752f84..7ac88ff 100644
> --- a/net/mac80211/wpa.c
> +++ b/net/mac80211/wpa.c
> @@ -127,7 +127,7 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
>                  * APs with pairwise keys should never receive Michael MIC
>                  * errors for non-zero keyidx because these are reserved for
>                  * group keys and only the AP is sending real multicast
> -                 * frames in the BSS. (
> +
> * frames in the BSS.
>                  */
>                 return RX_DROP_UNUSABLE;
>         }

Indent of single backspace needed:-)
