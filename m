Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46928 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2F1SEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 14:04:24 -0400
Message-ID: <1340906664.4491.47.camel@jlt3.sipsolutions.net> (sfid-20120628_200427_675054_DAFD537B)
Subject: Re: [RFC 60g 2/5] wireless: rate check logic for 60g
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 28 Jun 2012 20:04:24 +0200
In-Reply-To: <1340882220-31768-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120628_131759_318555_7C6D3DF7)
References: <1340882220-31768-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1340882220-31768-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 (sfid-20120628_131759_318555_7C6D3DF7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-28 at 14:16 +0300, Vladimir Kondratiev wrote:

> +		/*
> +		 * on 60gHz band, there are no legacy rates, so
> +		 * n_bitrates is 0
> +		 */
> +		if (WARN_ON((band != IEEE80211_BAND_60GHZ) &&
> +		    !sband->n_bitrates))
>  			return -EINVAL;

Please fix indentation.

johannes

