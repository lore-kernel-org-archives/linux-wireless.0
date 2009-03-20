Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56759 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751880AbZCTUgb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 16:36:31 -0400
Date: Fri, 20 Mar 2009 13:13:26 -0700
From: Greg KH <greg@kroah.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	otus-devel@lists.madwifi-project.org
Subject: Re: [RFC][RFT][PATCH 0/5 v5] ar9170: ar9170 driver (aka mac80211's
	otus)
Message-ID: <20090320201326.GA30639@kroah.com> (sfid-20090320_213634_971538_999D3AA7)
References: <200903170408.12626.chunkeey@web.de> <200903202036.09255.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200903202036.09255.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 20, 2009 at 08:36:08PM +0100, Christian Lamparter wrote:
> Based on the number of mails I got, this driver should be ready for inclusion.
> So, this is probably the last RFC and the official patches will follow on
> sunday (only if no one finds a bug that needs to be fixed ASAP.)

Wonderful!

When the driver goes into the "real" portion of drivers/net please let
me know and I'll drop the otus driver from the drivers/staging/
location.

thanks,

greg k-h
