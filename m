Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51696 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab0C2SAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 14:00:10 -0400
Date: Mon, 29 Mar 2010 13:55:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ext-saravanan.dhanabal@nokia.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Reschedule dynamic power save timer after
	wakeup
Message-ID: <20100329175506.GE4984@tuxdriver.com>
References: <1268753462-18094-1-git-send-email-ext-saravanan.dhanabal@nokia.com> <1268775761.8918.0.camel@jlt3.sipsolutions.net> <04BB8F4F2843A24294353CA037CA5B58568D26B52F@NOK-EUMSG-01.mgdnok.nokia.com> <1268841668.5989.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1268841668.5989.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 17, 2010 at 09:01:08AM -0700, Johannes Berg wrote:
> On Wed, 2010-03-17 at 12:09 +0100, ext-saravanan.dhanabal@nokia.com
> wrote:
> > In worst case it takes up to that much,  though the average is less but still significant. 
> 
> > On Tue, 2010-03-16 at 11:31 -0400, Saravanan Dhanabal wrote:
> > > After last transmission, the device goes to sleep earlier
> > > than the configured dynamic power save timeout. If timeout
> > > is set to 400ms, device enters into sleep mode at around
> > > 330ms since from last TX.
> 
> I still don't think I understand this patch. Why would you be interested
> in the exact timing rather than the time since the transmission? I
> mean ... why does it go to sleep _earlier_?

Any further comments on this one?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
