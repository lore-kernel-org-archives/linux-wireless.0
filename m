Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33740 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab1KHOPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 09:15:14 -0500
Date: Tue, 8 Nov 2011 09:08:17 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Luciano Coelho <coelho@ti.com>
Cc: Eyal Shapira <eyal@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl12xx: fix wl12xx_scan_sched_scan_ssid_list() check
 that all given ssids are in filters
Message-ID: <20111108140817.GA2776@tuxdriver.com> (sfid-20111108_151526_904077_45963D3E)
References: <1320756132-14625-1-git-send-email-eyal@wizery.com>
 <1320756479.19479.6.camel@cumari>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1320756479.19479.6.camel@cumari>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 08, 2011 at 02:47:59PM +0200, Luciano Coelho wrote:
> On Tue, 2011-11-08 at 14:42 +0200, Eyal Shapira wrote: 
> > A minor fix for the check that verifies that all given SSIDs (in req) exist
> > in the filters (the match sets)
> > 
> > Signed-off-by: Eyal Shapira <eyal@wizery.com>
> > ---
> 
> Acked-by: Luciano Coelho <coelho@ti.com>
> 
> John, can you apply this to 3.2, please?

Can someone bounce me a fresh copy? :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
