Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34898 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965052AbbLOMLM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2015 07:11:12 -0500
Message-ID: <1450181469.3356.7.camel@sipsolutions.net> (sfid-20151215_131127_772092_4168FFD5)
Subject: Re: [PATCH] nl80211: Fix potential memory leak in nl80211_set_wowlan
From: Johannes Berg <johannes@sipsolutions.net>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Ola Olsson <ola.olsson@sonymobile.com>
Date: Tue, 15 Dec 2015 13:11:09 +0100
In-Reply-To: <1449958637-2766-1-git-send-email-ola1olsson@gmail.com> (sfid-20151212_231724_074833_43795AD0)
References: <1449958637-2766-1-git-send-email-ola1olsson@gmail.com>
	 (sfid-20151212_231724_074833_43795AD0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-12-12 at 23:17 +0100, Ola Olsson wrote:
> Compared to cfg80211_rdev_free_wowlan in core.h,
> the error goto label lacks the freeing of nd_config.
> Fix that.
> 
Applied.

johannes
