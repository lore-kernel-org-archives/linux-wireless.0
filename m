Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35364 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbaJJPJM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 11:09:12 -0400
Message-ID: <1412953747.3206.2.camel@jlt4.sipsolutions.net> (sfid-20141010_170914_847834_AB4AE871)
Subject: Re: [PATCH] mac80211: enable DFS with channel contexts
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 10 Oct 2014 17:09:07 +0200
In-Reply-To: <1412937803-2413-1-git-send-email-michal.kazior@tieto.com> (sfid-20141010_125431_750437_BC06F367)
References: <1412937803-2413-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20141010_125431_750437_BC06F367)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-10-10 at 12:43 +0200, Michal Kazior wrote:
> It is okay to enable DFS for channel contexts
> based drivers as long as no combination advertises
> radar detection and multi-channel operation at the
> same time.

Applied.

johannes

