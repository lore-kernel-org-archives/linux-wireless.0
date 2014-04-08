Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38662 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbaDHNZZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 09:25:25 -0400
Message-ID: <1396963511.11971.1.camel@jlt4.sipsolutions.net> (sfid-20140408_152551_871628_0C394A54)
Subject: Re: [PATCH v3 04/13] mac80211: add support for radar detection for
 reservations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 08 Apr 2014 15:25:11 +0200
In-Reply-To: <1396262371-6466-5-git-send-email-michal.kazior@tieto.com> (sfid-20140331_134312_842038_BDFF4F7F)
References: <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	 <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
	 <1396262371-6466-5-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140331_134312_842038_BDFF4F7F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-31 at 12:39 +0200, Michal Kazior wrote:
> Initial chanctx reservation code wasn't aware of
> radar detection requirements. This is necessary
> for chanctx reservations to be used for channel
> switching in the future.

>  int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
>  				  const struct cfg80211_chan_def *chandef,
> -				  enum ieee80211_chanctx_mode mode)
> +				  enum ieee80211_chanctx_mode mode,
> +				  bool radar_required)

Does this not have any callers?

johannes

