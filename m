Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:42437 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab2KQAIH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 19:08:07 -0500
Date: Fri, 16 Nov 2012 16:10:46 -0800
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Arend van Spriel <arend@broadcom.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Mahesh Palivela <maheshp@posedge.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: VHT support, take 2
Message-ID: <20121117001046.GP3354@lenteja.do-not-panic.com> (sfid-20121117_010812_345955_92E68DD3)
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
 <1352492493.28302.7.camel@jlt4.sipsolutions.net>
 <50A4DB80.2020209@posedge.com>
 <1353072509.9490.7.camel@jlt4.sipsolutions.net>
 <50A65443.2000101@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <50A65443.2000101@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 16, 2012 at 03:57:07PM +0100, Arend van Spriel wrote:
> On 11/16/2012 02:28 PM, Johannes Berg wrote:
> >On Thu, 2012-11-15 at 17:39 +0530, Mahesh Palivela wrote:
> >
> >>vht regulatory code already posted long back. After went through several
> >>back n forth emails from Luis Rodriguez, accepted the patch.
> >>But not commited anywhere.
> >>Now I have to change that to match to new structs like chan_def etc from
> >>the vht channel work patches you posted 5 days back.
> >>
> >>Also helper funcs to replace chan->flags bit checking to dynamically
> >>check channel through regulatory
> >
> >Yeah, actually I'm not sure it's that easy. We'll also need per
> >bandwidth TX power restrictions, raise the 40 MHz bandwidth restriction
> >to 160 MHz (or get rid of it entirely), etc. That seems to require a new
> >regulatory database format?
> 
> Luis discussed the regulatory framework during the wireless summit
> in Barcelona last week. My (possibly limited) recollection was that
> the current regulatory code can accommodate VHT limits as well. I
> assume that also includes the regulatory database format.

The only thing mentioned which I had not considered is the per bandwidth
TX power restrictions. Where did these come from ?

  Luis
