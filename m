Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46306 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728509AbeHMO7L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 10:59:11 -0400
Date: Mon, 13 Aug 2018 14:17:07 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: allow to build without
 CFG80211_REQUIRE_SIGNED_REGDB
Message-ID: <20180813121706.GB2153@redhat.com> (sfid-20180813_141754_421420_73EAF17B)
References: <1533898547-14449-1-git-send-email-sgruszka@redhat.com>
 <1534154953.3093.1.camel@sipsolutions.net>
 <20180813114443.GA2153@redhat.com>
 <1534160873.3093.9.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534160873.3093.9.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 13, 2018 at 01:47:53PM +0200, Johannes Berg wrote:
> Disagree, if anything should be changed, it should be changed to
> 
>   default y if !CERTIFICATION_ONUS
> 
> but I prefer the way it works now, since it means setting certification
> onus won't immediately change this setting.

Ok, this works as supposed. Not sure why it did not work for me
before, maybe I just confused config options.

Regards
Stanislaw
