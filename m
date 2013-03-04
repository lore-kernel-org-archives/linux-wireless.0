Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42140 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757755Ab3CDPSv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:18:51 -0500
Message-ID: <1362410325.21028.20.camel@jlt4.sipsolutions.net> (sfid-20130304_161855_127685_A4B5D270)
Subject: Re: [PATCH 1/2] mac80211: remove napi
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Date: Mon, 04 Mar 2013 16:18:45 +0100
In-Reply-To: <1362041352-13110-1-git-send-email-sgruszka@redhat.com>
References: <1362041352-13110-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-28 at 09:49 +0100, Stanislaw Gruszka wrote:
> Since two years no mac80211 driver implement support for NAPI. Looks
> this feature is unneeded, so remove it from generic mac80211 code.

Applied.

johannes

