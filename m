Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:39755 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbaLXDbZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 22:31:25 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21658.13327.479459.295983@gargle.gargle.HOWL> (sfid-20141224_043129_513209_848CE2D0)
Date: Wed, 24 Dec 2014 09:03:35 +0530
To: TGK <tg.kiran@igate.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: MAC80211 dynamic powersave freeze
In-Reply-To: <loom.20141224T035621-218@post.gmane.org>
References: <loom.20141224T035621-218@post.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TGK wrote:
> Having investigated the logs, we have observed that the crash is mainly 
> occurring due to mac80211 dynamic power save module.  Following information 
> is recorded in log every time prior to crash/system freeze.

It could be a problem with ath9k, since error messages from ath9k are
seen in the log. Moreover your version is using ath9k rate control, which
has been removed from the driver.

> 2.  Is there a fix available in latest/recent version of compat or
> backports. In which version of compat is thee fix available?

3.3 is close to two years old. Using a more recent backports package
would be good.

> 3.  If I disable dynamic power save in mac80211, would it solve my
> problem?

PS has been disabled by default in STA mode for ath9k.

Sujith
