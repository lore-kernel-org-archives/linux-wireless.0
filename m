Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:38825 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753377AbYLIPQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 10:16:16 -0500
Message-ID: <493E8BBE.5010002@lwfinger.net> (sfid-20081209_161620_052250_9C76B7FD)
Date: Tue, 09 Dec 2008 09:16:14 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] p54usb: rewriting rx/tx routines to make use of	usb_anchor's
 facilities
References: <200812091514.37634.chunkeey@web.de>	 <20081209143530.GA3653@tuxdriver.com>	 <1228833999.1029.0.camel@johannes.berg>	 <20081209145439.GB3653@tuxdriver.com> <1228834985.1029.2.camel@johannes.berg>
In-Reply-To: <1228834985.1029.2.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> 
> There's no backtrace in that sense, it just hangs. I dumped it with
> sysrq-w but that wasn't too helpful...
> 

On x86_64 with rtl8187, I get a GPF due to a pointer being "poisoned". Perhaps
my platform will get a similar backtrace with p54usb. I hadn't tried it.

Larry
