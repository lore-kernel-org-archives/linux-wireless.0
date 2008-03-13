Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms5.Sony.CO.JP ([211.125.136.201]:51809 "EHLO ms5.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbYCMHCj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2008 03:02:39 -0400
Date: Thu, 13 Mar 2008 16:01:37 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] PS3: gelic: ignore scan info from zero SSID beacons
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	cbe-oss-dev@ozlabs.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Stefan Assmann <sassmann@suse.de>
In-Reply-To: <1205332991.15910.0.camel@johannes.berg>
References: <1205332288.6387.58.camel@johannes.berg> <1205332991.15910.0.camel@johannes.berg>
Message-Id: <20080313145319.2567.40F06B3A@sm.sony.co.jp> (sfid-20080313_070242_680001_258C8416)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 12 Mar 2008 15:43:11 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> 
> On Wed, 2008-03-12 at 15:31 +0100, Johannes Berg wrote:
> > > > >           Cell 02 - Address: 00:0A:79:A5:D2:E2
> > > > >                     ESSID:""
> > > > >                     Channel:0
> > > > >                     Encryption key:on
> > > > >                     Mode:Master
> > > > >                     Signal level=100/100  
> > > 
> > > Ewww.  You're 100% correct; we certainly shouldn't be sending a scan
> > > result like this to userspace.  Therefore:
> > 
> > I agree. Can you, however, tell whether the firmware has been fixed and
> > only skip these for broken firmware?
> 
> Oh, never mind, the patch will already do that. I agree with that
> completely :)

Dan, Johannes, thanks for your reviewing!

So now I again submit this patch although I said once that I withdrew.

Please apply this patch for 2.6.25.

Thanks in advance.

-- 
Masakazu MOKUNO

