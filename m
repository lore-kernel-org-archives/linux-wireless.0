Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40630 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab3EXUKV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 16:10:21 -0400
Message-ID: <1369426217.8290.22.camel@jlt4.sipsolutions.net> (sfid-20130524_221025_949207_75DABA92)
Subject: Re: [PATCH v2 1/2] cfg80211/nl80211: rename packet pattern related
 structures and enums
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Fri, 24 May 2013 22:10:17 +0200
In-Reply-To: <1369344908-11184-1-git-send-email-bzhao@marvell.com>
References: <1369344908-11184-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-23 at 14:35 -0700, Bing Zhao wrote:

> -enum nl80211_wowlan_packet_pattern_attr {

I think you missed a #define for this?

> +/* only for backward compatibility */
> +#define __NL80211_WOWLAN_PKTPAT_INVALID __NL80211_INVALID,

that , at the end looks like a copy/paste error, but in fact shouldn't
it be "__NL80211_PKTPAT_INVALID" anyway?


>   * that is part of %NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED in the
>   * capability information given by the kernel to userspace.

Should this be updated?

johannes

