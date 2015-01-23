Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35465 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbbAWJvr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 04:51:47 -0500
Message-ID: <1422006704.2728.15.camel@sipsolutions.net> (sfid-20150123_105150_475544_4992F378)
Subject: Re: [PATCH mac80211-next] nl80211: Allow set network namespace by fd
From: Johannes Berg <johannes@sipsolutions.net>
To: Vadim Kochan <vadim4j@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Jan 2015 10:51:44 +0100
In-Reply-To: <1421073245-20312-1-git-send-email-vadim4j@gmail.com> (sfid-20150112_154435_236040_68404050)
References: <1421073245-20312-1-git-send-email-vadim4j@gmail.com>
	 (sfid-20150112_154435_236040_68404050)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-01-12 at 16:34 +0200, Vadim Kochan wrote:
> From: Vadim Kochan <vadim4j@gmail.com>
> 
> Added new NL80211_ATTR_NETNS_FD which allows to
> set namespace via nl80211 by fd.

Applied.

johannes

