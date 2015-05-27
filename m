Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50835 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbbE0NGS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2015 09:06:18 -0400
Message-ID: <1432731975.2159.9.camel@sipsolutions.net> (sfid-20150527_150627_136146_BCF592E7)
Subject: Re: [PATCH v2] cfg80211: properly send
 NL80211_ATTR_DISCONNECTED_BY_AP in disconnect
From: Johannes Berg <johannes@sipsolutions.net>
To: "Mauger, MatthieuX" <matthieux.mauger@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
Date: Wed, 27 May 2015 15:06:15 +0200
In-Reply-To: <EE7846CC97FF2445A19665ED0567DD8E2E7D6A32@HASMSX105.ger.corp.intel.com>
References: <1432646540-28707-1-git-send-email-johannes@sipsolutions.net>
	 <EE7846CC97FF2445A19665ED0567DD8E2E7D6A32@HASMSX105.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-05-27 at 13:04 +0000, Mauger, MatthieuX wrote:
> Hi Johannes,
> 
> I'm about to merge the patch on our branch but I just want a little confirmation:
> In libertas driver, there is still one disconnect called with an hardcoded "true" rather than using the new introduced locally_generated.
> Is it volunteer or did you miss it ?

That was intentional.

johannes

