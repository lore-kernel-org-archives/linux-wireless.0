Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45896 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab2EEPTO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 May 2012 11:19:14 -0400
Message-ID: <1336231147.3716.0.camel@jlt3.sipsolutions.net> (sfid-20120505_171918_367523_3FB79D47)
Subject: Re: [PATCH] mac80211: Fix 'suspicious RCU usage' warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Sat, 05 May 2012 17:19:07 +0200
In-Reply-To: <4fa3dcf0.+lkNsTVufgE2rrvO%Larry.Finger@lwfinger.net>
References: <4fa3dcf0.+lkNsTVufgE2rrvO%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-05-04 at 08:43 -0500, Larry Finger wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> 
> When running kernel 3.4-rc2 from wireless testing, the following is logged:

> Reported-and-tested-by:: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Wait wait, I never signed this off yet. You really can't pretend I did.

johannes

