Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:53151 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab2KQXb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 18:31:28 -0500
Date: Sat, 17 Nov 2012 15:34:09 -0800
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Arend van Spriel <arend@broadcom.com>,
	Mahesh Palivela <maheshp@posedge.com>,
	<linux-wireless@vger.kernel.org>, <green@qca.qualcomm.com>,
	<dquan@qca.qualcomm.com>
Subject: Re: VHT support, take 2
Message-ID: <20121117233409.GT3354@lenteja.do-not-panic.com> (sfid-20121118_003135_008442_27745AB0)
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
 <1352492493.28302.7.camel@jlt4.sipsolutions.net>
 <50A4DB80.2020209@posedge.com>
 <1353072509.9490.7.camel@jlt4.sipsolutions.net>
 <50A65443.2000101@broadcom.com>
 <20121117001046.GP3354@lenteja.do-not-panic.com>
 <1353142108.9543.4.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1353142108.9543.4.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 17, 2012 at 09:48:28AM +0100, Johannes Berg wrote:
> On Fri, 2012-11-16 at 16:10 -0800, Luis R. Rodriguez wrote:
> 
> > > >Yeah, actually I'm not sure it's that easy. We'll also need per
> > > >bandwidth TX power restrictions, raise the 40 MHz bandwidth restriction
> > > >to 160 MHz (or get rid of it entirely), etc. That seems to require a new
> > > >regulatory database format?
> > > 
> > > Luis discussed the regulatory framework during the wireless summit
> > > in Barcelona last week. My (possibly limited) recollection was that
> > > the current regulatory code can accommodate VHT limits as well. I
> > > assume that also includes the regulatory database format.
> > 
> > The only thing mentioned which I had not considered is the per bandwidth
> > TX power restrictions. Where did these come from ?
> 
> As usual, they come from the regulations :-)

Which one in particular decided to add per bandwidth
TX power restrictions for VHT ?

  Luis
