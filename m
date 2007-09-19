Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4679 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759639AbXISPKz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 11:10:55 -0400
Date: Wed, 19 Sep 2007 10:57:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: Please pull 'iwlwifi' branch of wireless-2.6
Message-ID: <20070919145749.GA5483@tuxdriver.com>
References: <20070918185040.GF4940@tuxdriver.com> <20070918.122258.82101397.davem@davemloft.net> <46F12414.8000900@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46F12414.8000900@garzik.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 19, 2007 at 09:28:52AM -0400, Jeff Garzik wrote:
> David Miller wrote:
> >Jeff, if you have no objections I'll pull this into net-2.6.24

> Given that there is now a large backlog of new drivers to review, I 
> think the preferred course of action would be to queue them into -mm 
> (via net-2.6.24) for wider review and testing, and then make sure they 
> all get a thorough review+ACK before pushing upstream.

FWIW, all of the wireless drivers posted recently have been in -mm
for some time thanks to Andrew's pulls of wireless-dev.

> So far, its sounding like each review has turned up stuff that wants 
> fixing before the drivers commented upon go upstream.

I'm sure there are things worth fixing.  Feel free to comment and
I/we will scramble to make the appropriate changes.

John
-- 
John W. Linville
linville@tuxdriver.com
