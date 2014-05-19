Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33483 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101AbaESNVu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 09:21:50 -0400
Message-ID: <1400503229.4273.1.camel@jlt4.sipsolutions.net> (sfid-20140519_152154_410128_AC04079D)
Subject: Re: [PATCH] mac80211: fix csa_couter_offs argument name in docbook
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, andrei.otcheretianski@intel.com
Date: Mon, 19 May 2014 14:40:29 +0200
In-Reply-To: <1400175128-25656-1-git-send-email-luca@coelho.fi>
References: <1400175128-25656-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-15 at 20:32 +0300, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> The csa_counter_offs was erroneously described as csa_counter_offs in
> the docbook section.
> 
> This fixes two warnings when making htmldocs (at least):
> 
> Warning(include/net/mac80211.h:3428): No description found for parameter 'csa_counter_offs[IEEE80211_MAX_CSA_COUNTERS_NUM]'
> Warning(include/net/mac80211.h:3428): Excess struct/union/enum/typedef member 'csa_offs' description in 'ieee80211_mutable_offsets'

Applied, with the subject typo and commit log fixed.

johannes

