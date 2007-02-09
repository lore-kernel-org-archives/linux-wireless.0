Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2350 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423154AbXBIAoa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Feb 2007 19:44:30 -0500
Date: Thu, 8 Feb 2007 19:05:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Jory A. Pratt" <geekypenguin@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: RFT bcm43xx: Really _GOOD_ news
Message-ID: <20070209000544.GC6303@tuxdriver.com>
References: <45C8E64B.1050605@lwfinger.net> <45CB69EE.4000102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <45CB69EE.4000102@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 08, 2007 at 12:20:30PM -0600, Jory A. Pratt wrote:
> Larry Finger wrote:
> > I have really _GOOD_ news!!!!! While reviewing the latest changes in the V4 specs, I found an
> > interchange of the PHY version and PHY revision fields, relative to the current V3 specs. Of the
> > three cards that I have, the 4306 had the same value for the PHY version and revision. In addition,
> > it was the only card of the 3 thaw would work at 11Mbs. A light went on!
> >
> > After installing the patch listed below, both my 4318 and my 4311 will now run at 11Mbs. From tests
> > with iperf, I now get rates of 6.1 - 6.5 Mbs from all three.

> I have tested this until I am blue in the face on a 4318. It killed me,
> I was getting less then 200k/b a sec on a 5M pipe :(. I reverted the
> patch and all is back to working even tho transfering files on the
> internal network is still way out there.

Jory,

Have you tried the patch Larry posted yesterday w/ subject "RFT:
The real fix for BCM4311 and BCM4312"?

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
