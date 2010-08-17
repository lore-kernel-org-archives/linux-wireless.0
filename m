Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40456 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab0HQOsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 10:48:33 -0400
Subject: Re: STA mode bandwidth issues
From: Johannes Berg <johannes@sipsolutions.net>
To: ramakanth varala <ramakanth.varala@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTikQ+mYbt1gEx7DkV8Jt=Mqe+ojLrUmPCfKKg4Fj@mail.gmail.com>
References: <AANLkTikQ+mYbt1gEx7DkV8Jt=Mqe+ojLrUmPCfKKg4Fj@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 16:48:30 +0200
Message-ID: <1282056510.3747.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-08-17 at 20:10 +0530, ramakanth varala wrote:

> ifconfig ath0 down
> wlanconfig ath0 destroy
> wlanconfig ath0 create wlandev wifi0 wlanmode sta

> You'r views would be highly appreciated.

My view is that you shouldn't be using madwifi.

However, if you insist, you should ask any questions related to it on
the appropriate madwifi list, not here.

johannes

