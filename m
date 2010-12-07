Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:58976 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab0LGIta (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 03:49:30 -0500
Received: by pxi15 with SMTP id 15so2031210pxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 00:49:30 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19709.62713.669075.259794@gargle.gargle.HOWL>
Date: Tue, 7 Dec 2010 14:18:57 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Sujith <m.sujith@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k_htc: Fix suspend/resume
In-Reply-To: <AANLkTimq7F1UmRV=thdyRy1TozDGc4RbfniDYvBr2KUK@mail.gmail.com>
References: <19701.62091.644444.121284@gargle.gargle.HOWL>
	<20101202193024.GC2358@tuxdriver.com>
	<19704.23185.565826.890275@gargle.gargle.HOWL>
	<AANLkTinPLPoAHxauaXj8Sj=zjyHQPyxO0ku342ersZQ4@mail.gmail.com>
	<19709.45926.38551.25130@gargle.gargle.HOWL>
	<AANLkTinNF2dnacLof_knM3OAf6ADCCPsb8DO1VE6c31U@mail.gmail.com>
	<19709.46740.86437.390791@gargle.gargle.HOWL>
	<AANLkTinJLRMSSvLHgPP1Dw5BXsC3utAudJ=oSAsUUD8T@mail.gmail.com>
	<19709.59888.682471.11803@gargle.gargle.HOWL>
	<AANLkTimq7F1UmRV=thdyRy1TozDGc4RbfniDYvBr2KUK@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> Hm, well I was thinking more along the lines of what
> ath9k_htc_config() already does with IEEE80211_CONF_CHANGE_IDLE when
> enabling the radio. That seems right.

Not sure, maybe ath9k has issues handling CONF_IDLE.

Sujith
