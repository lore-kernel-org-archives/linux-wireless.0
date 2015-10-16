Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48387 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbbJPUYY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 16:24:24 -0400
Message-ID: <1445027060.2370.25.camel@sipsolutions.net> (sfid-20151016_222427_807056_342E531F)
Subject: Re: [RFC PATCH 1/2] cfg80211: Add support for ITS-G5 band (5.9 GHz)
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Sojka <sojkam1@fel.cvut.cz>,
	Jan Kaisrlik <kaisrja1@fel.cvut.cz>,
	wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, bernd.lehmann@volkswagen.de,
	jan-niklas.meier@volkswagen.de, s.sander@nordsys.de
Date: Fri, 16 Oct 2015 22:24:20 +0200
In-Reply-To: <87h9lqeplf.fsf@steelpick.2x.cz>
References: <1444994885-21825-1-git-send-email-kaisrja1@fel.cvut.cz>
	 <1444997197.2370.22.camel@sipsolutions.net>
	 <87h9lqeplf.fsf@steelpick.2x.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I thought that the regdb is for unlicensed bands with unrestricted use.
> The 5.9 GHz band is not licensed but it is restricted for ITS
> applications. 

It kind of is, at least the current one is.

> In http://marc.info/?l=linux-wireless&m=140183393707445&w=2
> Luis Rodriguez suggested that having a Kconfig option may be the way to
> go, but we may misread what he was saying.

I didn't really follow this.

> I assume that if this band will be in regdb, it will be too easy to use
> this band (e.g. by mistake) for non-ITS applications.

Does the *regulatory* actually prohibit that anyway though?

> Our goal is to make it easier for people to experiment with ITS in
> controlled environment (e.g. in a university lab). So you suggest that
> this should be enabled by providing custom regdb rather than recompiling
> the kernel with CFG80211_CERTIFICATION_ONUS?

Yes, that was exactly my thought.

johannes
