Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55417 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbbKCJ3Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 04:29:16 -0500
Message-ID: <1446542954.29010.3.camel@sipsolutions.net> (sfid-20151103_103232_481123_7923CC6D)
Subject: Re: [PATCH 01/14] mac80211: fix divide by zero when NOA update
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 03 Nov 2015 10:29:14 +0100
In-Reply-To: <1445931311-14091-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151027_083528_380787_657143AA)
References: <1445931311-14091-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20151027_083528_380787_657143AA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-10-27 at 08:35 +0100, Janusz Dziedzic wrote:
> In case of one shot NOA the interval could be 0.
> 
Applied, thanks!

johannes
