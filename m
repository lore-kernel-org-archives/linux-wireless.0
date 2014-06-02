Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55200 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbaFBLCY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 07:02:24 -0400
Message-ID: <1401706931.4303.2.camel@jlt4.sipsolutions.net> (sfid-20140602_130227_780713_118F6206)
Subject: Re: [PATCH] mac80211: remove PID rate control
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Mattias Nissler <mattias.nissler@gmx.de>
Date: Mon, 02 Jun 2014 13:02:11 +0200
In-Reply-To: <1401461248-29427-1-git-send-email-linville@tuxdriver.com> (sfid-20140530_170022_501559_C48F8145)
References: <1401461248-29427-1-git-send-email-linville@tuxdriver.com>
	 (sfid-20140530_170022_501559_C48F8145)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-30 at 10:47 -0400, John W. Linville wrote:
> Minstrel has long since proven its worth.

I thought that some drivers still used this one, but I guess none
actually do. Applied.

johannes

