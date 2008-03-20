Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3402 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbYCTVHi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2008 17:07:38 -0400
Date: Thu, 20 Mar 2008 16:31:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Adam Turk <bofh1234@hotmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: 2.6.25-rc6, rausb0 or wlan0 or both???
Message-ID: <20080320203124.GB30762@tuxdriver.com> (sfid-20080320_210742_972862_3C950758)
References: <BAY101-W2F265A1ACEEAD6E11D953C8000@phx.gbl> <1205976828.16475.92.camel@johannes.berg> <BAY101-W21790F71EFEF146FF9E2AC8000@phx.gbl> <1205982479.16475.94.camel@johannes.berg> <BAY101-W232F4828EE4528854F6860C8000@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BAY101-W232F4828EE4528854F6860C8000@phx.gbl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 20, 2008 at 11:02:59AM -0400, Adam Turk wrote:
> 
> > Subject: RE: 2.6.25-rc6, rausb0 or wlan0 or both???
> > From: johannes@sipsolutions.net
> >
> > The kernel works fine, airmon-ng relies on iw.
> >
> > johannes
> 
> OK.  I wasn't aware that airmon-ng relies on iw now.  Is there a tar.gz that I can download?
> 
> However this still doesn't explain why rausb0 still works when it should be wlan0.

This is probably due to udev.  Look for a file with a name like
"/etc/udev/rules.d/70-persistent-net.rules" -- the actual name may
vary by distribution.

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
