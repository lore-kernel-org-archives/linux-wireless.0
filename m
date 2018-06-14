Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52836 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754854AbeFNLFW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 07:05:22 -0400
Message-ID: <1528974316.26847.0.camel@sipsolutions.net> (sfid-20180614_130540_449813_87A0697F)
Subject: Re: [B.A.T.M.A.N.] [PATCH v2 3/5] batman: use BIT_ULL for
 NL80211_STA_INFO_* attribute types
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Eckelmann <sven@narfation.org>,
        b.a.t.m.a.n@lists.open-mesh.org
Cc: Omer Efrat <omer.efrat@tandemg.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date: Thu, 14 Jun 2018 13:05:16 +0200
In-Reply-To: <1567584.jbsRn7ofiA@bentobox> (sfid-20180614_125324_149221_2D722F3B)
References: <1528971137-432-1-git-send-email-omer.efrat@tandemg.com>
         <32533954.9n15W0HXMB@bentobox> <1567584.jbsRn7ofiA@bentobox>
         (sfid-20180614_125324_149221_2D722F3B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-06-14 at 12:53 +0200, Sven Eckelmann wrote:
> Hi,
> 
> here are the infos which were missing and which should be included in the 
> commit message
> 
> > > Since 'filled' member in station_info changed to u64
> 
> in commit 739960f128e5 ("cfg80211/nl80211: Add support for 
> NL80211_STA_INFO_RX_DURATION")

Yeah, which actually means this patch isn't needed?

BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT) is fine since
NL80211_STA_INFO_EXPECTED_THROUGHPUT is actually == 27.

johannes
