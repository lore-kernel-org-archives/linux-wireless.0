Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:58865 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbYK0ET2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 23:19:28 -0500
Received: by wf-out-1314.google.com with SMTP id 27so804538wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 20:19:28 -0800 (PST)
Message-ID: <b6c5339f0811262019j4e329119pa99bae48e0ffa745@mail.gmail.com> (sfid-20081127_051936_062542_E2ABC0EB)
Date: Wed, 26 Nov 2008 23:19:27 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: jirislaby@gmail.com, nbd@openwrt.org, lrodriguez@atheros.com,
	mickflemm@gmail.com, linville@tuxdriver.com
Subject: Re: [PATCH 2/3] ath5k: clean up ath5k_hw_set_key
Cc: "Bob Copeland" <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081126211718.16875.65815.sendpatchset@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081126211711.16875.71258.sendpatchset@localhost>
	 <20081126211718.16875.65815.sendpatchset@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 26, 2008 at 4:17 PM, Bob Copeland <me@bobcopeland.com> wrote:
>
> +static
> +int ath5k_keycache_type(const struct ieee80211_key_conf *key)
> +{
> +       switch (key->alg) {
> +       case ALG_TKIP:
> +               return AR5K_KEYTABLE_TYPE_TKIP;
> +       case ALG_CCMP:
> +               return AR5K_KEYTABLE_TYPE_CCM;
> +       case ALG_WEP:
> +               if (key->len == WEP40)

Oops sorry, ignore this patch.  I broke it with a last minute interface change.
I'll repost the series tomorrow.

-- 
Bob Copeland %% www.bobcopeland.com
