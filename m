Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:62283 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab3KTIFS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 03:05:18 -0500
Received: by mail-vc0-f170.google.com with SMTP id ht10so2947997vcb.29
        for <linux-wireless@vger.kernel.org>; Wed, 20 Nov 2013 00:05:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFSJ42Y_Ge=bbp49DQkrAvK5+cqkPHqOu=mHQghWv9Q5rzxeZA@mail.gmail.com>
References: <1384870413-5569-1-git-send-email-yeohchunyeow@gmail.com>
	<CAFSJ42ZLhh5ns-aaO8G38TH1em37iHnYKvgF7BjSK-ZhA7jNcA@mail.gmail.com>
	<CAEFj986hb2BLvcF2Bz3jRb_BRq3b+jZ5FwWALc0gdjXhLFU8tA@mail.gmail.com>
	<CAFSJ42YQ5aKo+8NH-rvi_pm7dudpqpWYLJ69JpzKg_7agiOeKg@mail.gmail.com>
	<CAEFj9859MXVE5L1Diiw0cNsaNPaNEYPddm0Fjco5hJGJpLtNSA@mail.gmail.com>
	<CAFSJ42Y_Ge=bbp49DQkrAvK5+cqkPHqOu=mHQghWv9Q5rzxeZA@mail.gmail.com>
Date: Wed, 20 Nov 2013 16:05:17 +0800
Message-ID: <CAEFj9848cv_wGUUhR2fCD-yp5ptziLJkyk6SvukcbbcSh83Y1A@mail.gmail.com> (sfid-20131120_090522_889521_8C2128EC)
Subject: Re: [PATCH] wcn36xx: set self sta entry as HT capable
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	wcn36xx <wcn36xx@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alright, I will resubmit the patch with these as default value.

---
Chun-Yeow

On Wed, Nov 20, 2013 at 3:55 PM, Eugene Krasnikov <k.eugene.e@gmail.com> wrote:
> Most of these values are taken from wcn_band_2ghz
>
> Will try to remember:
>
> sta_params->ht_capable = 1
> sta_params->tx_channel_width_set = 1
> sta_params->lsig_txop_protection = 1
> sta_params->max_ampdu_size = 3 // Might be wrong but let's have this
> value as a begining.
> sta_params->max_ampdu_density = 5 // Might be wrong but let's have
> this value as a begining.
> sta_params->max_amsdu_size = 0
> sta_params->sgi_20Mhz = 1
> sta_params->sgi_40mhz = 1
> sta_params->green_field_capable = 1
> sta_params->delayed_ba_support = 0
> sta_params->dsss_cck_mode_40mhz = 1
