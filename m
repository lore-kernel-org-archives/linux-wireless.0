Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:45684 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527AbaGXMzJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 08:55:09 -0400
Message-ID: <1406206505.6621.4.camel@umadbro> (sfid-20140724_145535_710669_81BA1F78)
Subject: Re: [PATCH v2] cfg80211: Try multiple bandwidths when checking
 usable channels.
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de,
	Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Thu, 24 Jul 2014 14:55:05 +0200
In-Reply-To: <1406205820-18152-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1406205820-18152-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-07-24 at 14:43 +0200, Rostislav Lisovy wrote:
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index e46c437..919f759 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -3679,6 +3679,8 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
>   * freq_reg_info - get regulatory information for the given frequency
>   * @wiphy: the wiphy for which we want to process this rule for
>   * @center_freq: Frequency in KHz for which we want regulatory information for
> + * @desired_bw_khz: The bandwidth of the channel in KHz we want regulatory
> + *                  information for

Forgot to add this:
... or 0 to use the default bandwidth (20MHz)


Best regards;
Rostislav Lisovy

