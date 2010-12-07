Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38026 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab0LGR0U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 12:26:20 -0500
Received: by iwn9 with SMTP id 9so126312iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 09:26:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19709.62713.669075.259794@gargle.gargle.HOWL>
References: <19701.62091.644444.121284@gargle.gargle.HOWL> <20101202193024.GC2358@tuxdriver.com>
 <19704.23185.565826.890275@gargle.gargle.HOWL> <AANLkTinPLPoAHxauaXj8Sj=zjyHQPyxO0ku342ersZQ4@mail.gmail.com>
 <19709.45926.38551.25130@gargle.gargle.HOWL> <AANLkTinNF2dnacLof_knM3OAf6ADCCPsb8DO1VE6c31U@mail.gmail.com>
 <19709.46740.86437.390791@gargle.gargle.HOWL> <AANLkTinJLRMSSvLHgPP1Dw5BXsC3utAudJ=oSAsUUD8T@mail.gmail.com>
 <19709.59888.682471.11803@gargle.gargle.HOWL> <AANLkTimq7F1UmRV=thdyRy1TozDGc4RbfniDYvBr2KUK@mail.gmail.com>
 <19709.62713.669075.259794@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 7 Dec 2010 09:25:58 -0800
Message-ID: <AANLkTindJEbDowF4D46XGL3t3D8whn=LF2FG=3w3DdiV@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath9k_htc: Fix suspend/resume
To: Sujith <m.sujith@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 7, 2010 at 12:48 AM, Sujith <m.sujith@gmail.com> wrote:
> Luis R. Rodriguez wrote:
>> Hm, well I was thinking more along the lines of what
>> ath9k_htc_config() already does with IEEE80211_CONF_CHANGE_IDLE when
>> enabling the radio. That seems right.
>
> Not sure, maybe ath9k has issues handling CONF_IDLE.

Well ath9k was fine with enabling the radio, the issue was with it not
getting a now we're idle notification later on in certain cases.

  Luis
