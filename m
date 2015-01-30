Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54487 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762307AbbA3OGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 09:06:39 -0500
Message-ID: <1422626790.1919.22.camel@sipsolutions.net> (sfid-20150130_150645_335192_0EAD6FEE)
Subject: Re: [PATCH v2 2/7] ath10k: implement chanctx API
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 30 Jan 2015 15:06:30 +0100
In-Reply-To: <CA+BoTQ=YnQhjLwUU9jj_SBS_mji-pG=cYbdGtYusKC3pwVAirA@mail.gmail.com> (sfid-20150130_144728_059271_B371B04E)
References: <1422607287-12289-1-git-send-email-michal.kazior@tieto.com>
	 <1422621086-28970-1-git-send-email-michal.kazior@tieto.com>
	 <1422621086-28970-3-git-send-email-michal.kazior@tieto.com>
	 <1422621903.1919.7.camel@sipsolutions.net>
	 <CA+BoTQkdszYWbNJcV+1dDFsaSJ3aoTuC=ORUMr_aJx7_aQmcqw@mail.gmail.com>
	 <1422623054.1919.18.camel@sipsolutions.net>
	 <CA+BoTQnkqzHNWTFSc9VB4_itCK_+jC6HC8GmdMKiyrhu-Sz9Cg@mail.gmail.com>
	 <1422624670.1919.21.camel@sipsolutions.net>
	 <CA+BoTQ=YnQhjLwUU9jj_SBS_mji-pG=cYbdGtYusKC3pwVAirA@mail.gmail.com>
	 (sfid-20150130_144728_059271_B371B04E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-30 at 14:47 +0100, Michal Kazior wrote:

> I'm not sure if you refer to iwlwifi or mac80211 now? If it's the
> latter: even if you have an ops with, e.g. vif pointer, driver may
> still need to iterate over interfaces in order to propagate some
> side-effect changes or aggregate some values/recalculate.

I was referring mostly to iwlwifi :)

johannes

