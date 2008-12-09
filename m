Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:63031 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752738AbYLIPHV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 10:07:21 -0500
Message-ID: <493E89A7.3030700@lwfinger.net> (sfid-20081209_160724_279373_D0570964)
Date: Tue, 09 Dec 2008 09:07:19 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] p54usb: rewriting rx/tx routines to make use of	usb_anchor's
 facilities
References: <200812091514.37634.chunkeey@web.de> <20081209143530.GA3653@tuxdriver.com>
In-Reply-To: <20081209143530.GA3653@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> 
> That's a big patch for so late in the cycle.  Is there a bugzilla open for it?

There is a similar patch coming for rtl8187. I'll also open a bugzilla entry for
it as well.

Larry
