Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53266 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbbIRJMe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:12:34 -0400
Message-ID: <1442567551.2168.8.camel@sipsolutions.net> (sfid-20150918_111238_817928_7655FFE0)
Subject: Re: [PATCH] ibss: add VHT80 support for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 18 Sep 2015 11:12:31 +0200
In-Reply-To: <1441879453-6391-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150910_120449_596793_52B45E76)
References: <1441879453-6391-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20150910_120449_596793_52B45E76)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-09-10 at 12:04 +0200, Janusz Dziedzic wrote:
> Add VHT80 support for IBSS.
> 
> eg. iw wlan0 ibss join 5180 80MHZ
>     iw wlan0 ibbs join 5220 80MHZ
> 
Applied, with the obvious code style issue fixed.

johannes
