Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4177 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbXLDSUi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 13:20:38 -0500
Date: Tue, 4 Dec 2007 13:19:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Dave <kilroyd@googlemail.com>, linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH] [try 2] orinoco: more reliable scan handling
Message-ID: <20071204181950.GA28285@tuxdriver.com> (sfid-20071204_182057_187931_094B9DCB)
References: <1191946643.20183.2.camel@localhost.localdomain> <20071010183251.GK5962@tuxdriver.com> <1192074985.31110.4.camel@localhost.localdomain> <47489C2D.7030606@gmail.com> <1196790166.14628.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1196790166.14628.2.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 04, 2007 at 12:42:46PM -0500, Dan Williams wrote:
> On Sat, 2007-11-24 at 21:48 +0000, Dave wrote:
> > 
> > 
> > Dan Williams wrote:
> > > Bring scan result handling more in line with drivers like ipw.  Scan
> > > results are aggregated and a BSS dropped after 15 seconds if no beacon
> > > is received.  This allows the driver to interact better with userspace
> > > where more than one process may request scans or results at any time.
> > 
> > I've only seen this recently, and am using it as a basis for some other changes. However I've noticed a couple issues:
> 
> Will clean up these and submit for 2.6.25 then, thanks.

The patch is already queued in Jeff's tree.  Please send any changes
as new patches on top.

John
-- 
John W. Linville
linville@tuxdriver.com
