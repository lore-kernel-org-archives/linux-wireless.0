Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38993 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab3H3KDR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Aug 2013 06:03:17 -0400
Message-ID: <1377856990.16256.0.camel@jlt4.sipsolutions.net> (sfid-20130830_120320_388575_AEA4613E)
Subject: Re: [PATCH] mac80211: Remove superfluous is_multicast_ether_addr()
 call
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 30 Aug 2013 12:03:10 +0200
In-Reply-To: <1377812109-22889-1-git-send-email-ryazanov.s.a@gmail.com> (sfid-20130829_233509_319355_F32A4943)
References: <1377812109-22889-1-git-send-email-ryazanov.s.a@gmail.com>
	 (sfid-20130829_233509_319355_F32A4943)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-30 at 01:35 +0400, Sergey Ryazanov wrote:
> Remove superfluous call and use locally stored previous result.

Applied, thanks.

johannes

