Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32881 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965753AbaLLLZt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 06:25:49 -0500
Message-ID: <1418383544.2470.15.camel@sipsolutions.net> (sfid-20141212_122553_393225_B62BA340)
Subject: Re: [PATCH] cfg80211: avoid mem leak on driver hint set
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>, stable@vger.kernel.org
Date: Fri, 12 Dec 2014 12:25:44 +0100
In-Reply-To: <1417688536-9145-1-git-send-email-arik@wizery.com> (sfid-20141204_112214_696231_0EB56699)
References: <1417688536-9145-1-git-send-email-arik@wizery.com>
	 (sfid-20141204_112214_696231_0EB56699)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-12-04 at 12:22 +0200, Arik Nemtsov wrote:
> In the already-set and intersect case of a driver-hint, the previous
> wiphy regdomain was not freed before being reset with a copy of the
> cfg80211 regdomain.

Applied.

johannes

