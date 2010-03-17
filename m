Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49385 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab0CQQBI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 12:01:08 -0400
Subject: RE: [PATCH] mac80211: Reschedule dynamic power save timer after
 wakeup
From: Johannes Berg <johannes@sipsolutions.net>
To: ext-saravanan.dhanabal@nokia.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <04BB8F4F2843A24294353CA037CA5B58568D26B52F@NOK-EUMSG-01.mgdnok.nokia.com>
References: <1268753462-18094-1-git-send-email-ext-saravanan.dhanabal@nokia.com>
	 ,<1268775761.8918.0.camel@jlt3.sipsolutions.net>
	 <04BB8F4F2843A24294353CA037CA5B58568D26B52F@NOK-EUMSG-01.mgdnok.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 09:01:08 -0700
Message-ID: <1268841668.5989.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-17 at 12:09 +0100, ext-saravanan.dhanabal@nokia.com
wrote:
> In worst case it takes up to that much,  though the average is less but still significant. 

> On Tue, 2010-03-16 at 11:31 -0400, Saravanan Dhanabal wrote:
> > After last transmission, the device goes to sleep earlier
> > than the configured dynamic power save timeout. If timeout
> > is set to 400ms, device enters into sleep mode at around
> > 330ms since from last TX.

I still don't think I understand this patch. Why would you be interested
in the exact timing rather than the time since the transmission? I
mean ... why does it go to sleep _earlier_?

johannes

