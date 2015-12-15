Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34912 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964999AbbLOMMD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2015 07:12:03 -0500
Message-ID: <1450181521.3356.8.camel@sipsolutions.net> (sfid-20151215_131207_600667_98A25097)
Subject: Re: [PATCH] nl80211: Fix potential memory leak in nl80211_connect
From: Johannes Berg <johannes@sipsolutions.net>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Ola Olsson <ola.olsson@sonymobile.com>
Date: Tue, 15 Dec 2015 13:12:01 +0100
In-Reply-To: <1449864292-24509-1-git-send-email-ola1olsson@gmail.com> (sfid-20151211_210542_766543_BAF6577C)
References: <1449864292-24509-1-git-send-email-ola1olsson@gmail.com>
	 (sfid-20151211_210542_766543_BAF6577C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-12-11 at 21:04 +0100, Ola Olsson wrote:
> Free cached keys if the last early return path is taken.
> 
Also applied, thanks.

johannes
