Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:13005 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbXINIby (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2007 04:31:54 -0400
Received: by ug-out-1314.google.com with SMTP id z38so469857ugc
        for <linux-wireless@vger.kernel.org>; Fri, 14 Sep 2007 01:31:53 -0700 (PDT)
Message-ID: <46EA46F5.1050906@gmail.com>
Date: Fri, 14 Sep 2007 10:31:49 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/3] Internalize Atheros Turbo modes and Turbo modulation
References: <43e72e890709131706p565bd955m1b9820198cafa7fa@mail.gmail.com>
In-Reply-To: <43e72e890709131706p565bd955m1b9820198cafa7fa@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez napsal(a):
> This patch:
> 
> * Internalizes Atheros Turbo modes (MODE_ATHEROS_TURBO, MODE_ATHEROS_TURBOG)
> 
> * Internatizes Turbo modulation (MODULATION_TURBO)
> 
> * Adds documention for Atheros Turbo modes (MODE_ATHEROS_TURBO,
> MODE_ATHEROS_TURBOG), Turbo modulation (MODULATION_TURBO) and XR
> modulation (MODULATION_XR)
> 
> This patch is intended for the ath5k branch of wireless-dev after a
> pull from origin/everything once
> 01-remove-atheros-turbo-from-mac80211.diff is applied.
> 
> drivers/net/wireless/ath5k_base.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Changes-licensed-under: BSD
> Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
> 
> drivers/net/wireless/ath5k.h    |   86 +++++++++++++++++++++++++++++++++------
> drivers/net/wireless/ath5k_hw.c |    4 +-
> 2 files changed, 76 insertions(+), 14 deletions(-)
> 
> Changes-licensed-under: ISC
> Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
> 
> Cc: Zhu Yi <yi.zhu@intel.com>
> Cc: Jiri Slaby <jirislaby@gmail.com>
> Cc: Michael Wu <flamingice@sourmilk.net>
> CC: Johannes Berg <johannes@sipsolutions.net

Just a question if it doesn't affect somehow supp_rates/basic_rates, which
has up to NUM_IEEE80211_MODES pointers.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
