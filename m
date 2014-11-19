Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40054 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113AbaKSRut (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 12:50:49 -0500
Message-ID: <1416419444.9374.10.camel@sipsolutions.net> (sfid-20141119_185052_931748_297CB1C9)
Subject: Re: [PATCH] cfg80211: protect fools returning NULL in
 add_virtual_intf
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 19 Nov 2014 18:50:44 +0100
In-Reply-To: <1415987008-3557-1-git-send-email-zajec5@gmail.com> (sfid-20141114_184344_156615_F79F5890)
References: <1415987008-3557-1-git-send-email-zajec5@gmail.com>
	 (sfid-20141114_184344_156615_F79F5890)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-11-14 at 18:43 +0100, Rafał Miłecki wrote:
> Callback add_virtual_intf is supposed to return ERR_PTR and trying to
> return NULL results in some "Unable to handle kernel paging request",
> etc. As it may be complicated to debug & trace, let's catch it (WARN).

I guess we can do that.

johannes

