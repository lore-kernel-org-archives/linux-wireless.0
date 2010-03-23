Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f194.google.com ([209.85.222.194]:63116 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab0CWQcn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 12:32:43 -0400
Received: by pzk32 with SMTP id 32so389197pzk.4
        for <linux-wireless@vger.kernel.org>; Tue, 23 Mar 2010 09:32:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1269327754-995-3-git-send-email-juuso.oikarinen@nokia.com>
References: <1269327754-995-1-git-send-email-juuso.oikarinen@nokia.com>
	<1269327754-995-3-git-send-email-juuso.oikarinen@nokia.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 23 Mar 2010 09:21:44 -0700
Message-ID: <43e72e891003230921k27cdc6e1k82336e71f52975e1@mail.gmail.com>
Subject: Re: [PATCH 2/2] mac80211: Add support for connection quality
	monitoring
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	luciano.coelho@nokia.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 23, 2010 at 12:02 AM, Juuso Oikarinen
<juuso.oikarinen@nokia.com> wrote:
> Add support for the set_cqm_config op. This op function configures the
> requested connection quality monitor rssi threshold and rssi hysteresis
> values to the hardware  if the hardware supports
> IEEE80211_HW_SUPPORTS_CQM.
>
> For unsupporting hardware, currently -EOPNOTSUPP is returned, so the mac80211
> is currently not doing connection quality monitoring on the host. This could be
> added later, if needed.
>
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Thanks for the work Juuso, looks good. I'm so pleased at how changes
like these can be made so easily *and* are extremely easy to read
thanks to the good effort put into cfg80211/nl80211/mac80211. Night
and day compared to the old wext days.

  Luis
