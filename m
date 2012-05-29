Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48453 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2E2HKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 03:10:16 -0400
Message-ID: <1338275419.4342.19.camel@jlt3.sipsolutions.net> (sfid-20120529_091022_197205_5D920CB2)
Subject: Re: [PATCH 2/2] mac80211: handle channel times in scan command
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 29 May 2012 09:10:19 +0200
In-Reply-To: <1337885569-32711-2-git-send-email-victorg@ti.com>
References: <1337885569-32711-1-git-send-email-victorg@ti.com>
	 <1337885569-32711-2-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-24 at 21:52 +0300, Victor Goldenshtein wrote:
> Use the user scan times if those were set, otherwise
> use the default values.

I'd prefer the default values to be defined in cfg80211, not mac80211,
so that other drivers can also benefit once they add support for these
settings.

johannes

