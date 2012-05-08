Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59648 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab2EHOGE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 10:06:04 -0400
Message-ID: <1336485961.4320.1.camel@jlt3.sipsolutions.net> (sfid-20120508_160621_157639_49C5DA47)
Subject: Re: [PATCH] mac80211: add op to configure default key id to driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Yoni Divinsky <yoni.divinsky@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 08 May 2012 16:06:01 +0200
In-Reply-To: <1336479518-23006-1-git-send-email-yoni.divinsky@ti.com>
References: <1336479518-23006-1-git-send-email-yoni.divinsky@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-05-08 at 15:18 +0300, Yoni Divinsky wrote:
> When hw_accel is enabled and encryption type is set to WEP,
> the driver should get the default key index from mac80211.

Well, why?

johannes


