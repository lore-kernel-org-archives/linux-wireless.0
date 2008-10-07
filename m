Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46094 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbYJGSTj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 14:19:39 -0400
Date: Tue, 7 Oct 2008 14:18:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>, Dan Williams <dcbw@redhat.com>
Subject: Re: wpa supplicant interface up delay
Message-ID: <20081007181857.GB3287@tuxdriver.com> (sfid-20081007_201942_640785_7F2D69D5)
References: <1223403361.7328.71.camel@johannes.berg> <1223403498.7328.73.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223403498.7328.73.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 07, 2008 at 08:18:18PM +0200, Johannes Berg wrote:
> On Tue, 2008-10-07 at 20:16 +0200, Johannes Berg wrote:
> > * Wait some time to allow driver to initialize before
> >                          * starting configuring the driver. This seems to be  
> >                          * needed at least some drivers that load firmware etc.
> >                          * when the interface is set up.
> > 
> > which drivers are those, and why can't we fix the drivers instead? This
> > seems like a bug in the drivers that they return from their open
> > callback prematurely.
> 
> In any case, this delay should certainly be removed from the nl80211
> driver; when porting drivers to the new APIs we can make sure this is
> done correctly.

ACK

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
