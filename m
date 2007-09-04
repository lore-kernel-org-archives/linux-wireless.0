Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.239]:59284 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbXIDR54 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 13:57:56 -0400
Received: by wr-out-0506.google.com with SMTP id 36so898406wra
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2007 10:57:55 -0700 (PDT)
Message-ID: <1ba2fa240709041057w6113dd6ay5ad90f47ed113120@mail.gmail.com>
Date: Tue, 4 Sep 2007 20:57:54 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
Cc: "Zhu Yi" <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>,
	"Andy Green" <andy@warmcat.com>
In-Reply-To: <1188923691.9942.58.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1188875058.13078.428.camel@debian.sh.intel.com>
	 <1188923691.9942.58.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>

> Uh huh? Is that more workarounds for the hardware scanning?
>
> +               iwl_set_rxon_hwcrypto(priv, 1);
> +               iwl_commit_rxon(priv);
> +               key->flags &= ~IEEE80211_KEY_FORCE_SW_ENCRYPT;
> +               key->hw_key_idx = sta_id;
> +               IWL_DEBUG_MAC80211("set_key success, using hwcrypto\n");
>
> Since you're not going to be able to push the driver into .23 and .24
> will include mac80211 updates, how about making it compile with those
> updates? Hint: take patches from wireless-dev.
>
> + * The following adds a new attribute to the sysfs representation
> + * of this device driver (i.e. a new file in /sys/bus/pci/drivers/ipw/)
> + * used for controlling the debug level.
> + *
> + * See the level definitions in ipw for details.
>

> That interface should likely live in debugfs.
>
On the way as well

>
> Uh. Enough for now.
>
> johannes
>
>
