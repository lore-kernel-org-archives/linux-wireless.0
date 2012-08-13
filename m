Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54328 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab2HMPlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 11:41:21 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20521.8011.624016.146590@gargle.gargle.HOWL> (sfid-20120813_174124_730727_BFB8326E)
Date: Mon, 13 Aug 2012 21:07:47 +0530
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>
Subject: [RFC 2/3] ath9k_htc: Advertise interface combinations supported
In-Reply-To: <1344871339-6575-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1344871339-6575-1-git-send-email-mohammed@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan wrote:
> +static const struct ieee80211_iface_limit if_limits[] = {
> +	{ .max = 2,	.types = BIT(NL80211_IFTYPE_STATION) |
> +				 BIT(NL80211_IFTYPE_P2P_CLIENT) },
> +	{ .max = 2,	.types =
> +			BIT(NL80211_IFTYPE_AP) |
> +			BIT(NL80211_IFTYPE_P2P_GO) },
> +};

Well, P2P-GO/AP modes etc. are just broken in ath9k_htc.. but the patch could
go in, I guess. If you can fix the weird indentation. :)

Sujith
