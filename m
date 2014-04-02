Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33260 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbaDBNec (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2014 09:34:32 -0400
Message-ID: <1396445668.21619.0.camel@umadbro> (sfid-20140402_153452_114705_EAD928B3)
Subject: Re: [PATCH 0/5] cfg80211: Add channel attributes to be used with
 5/10MHz channels
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de,
	Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Wed, 02 Apr 2014 15:34:28 +0200
In-Reply-To: <1395996624.4175.8.camel@jlt4.sipsolutions.net>
References: <1394543114-6700-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140311_140522_704622_0C67DCB5) <1395996624.4175.8.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-28 at 09:50 +0100, Johannes Berg wrote:
> This looks fine, but you need to rebase. Also, maybe squash patches 1/2
> or something, the patches are pretty oddly split up IMHO, with nl80211.h
> updates in one patch and the nl80211.c in the other, for example.
> 
> It'd also be good to have some text in the empty commit logs of patches
> 3 and 5.

Thank you for the review. I just sent the v2 patch.

Regards;
Rostislav Lisovy


