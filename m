Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46128 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132AbYKEQyz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 11:54:55 -0500
Subject: Re: plan for libertas and mac80211 and cfg80211
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Cliff Brake <cliff.brake@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1225900330.3619.125.camel@johannes.berg>
References: <f96d234e0811050728t63f3793eqc395ff979dafd9f6@mail.gmail.com>
	 (sfid-20081105_162837_225849_AF63D3FD)  <1225900330.3619.125.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 11:53:02 -0500
Message-Id: <1225903982.25627.3.camel@localhost.localdomain> (sfid-20081105_175513_149574_03A3E989)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-11-05 at 16:52 +0100, Johannes Berg wrote:
> On Wed, 2008-11-05 at 10:28 -0500, Cliff Brake wrote:
> > Hello,
> > 
> > I am using the marvell 8686 in several projects.  Is there any plan to
> > move the libertas driver to mac80211 in the future?  
> 
> There's the libertas_tf driver that uses a different firmware, the
> libertas driver uses a smarter firmware that's "too smart" to be used
> with mac80211.

libertas_tf thin firmware is only compatible with usb8388 cards at this
time.

> > If not, will
> > cfg80211 mechanisms be supported with this driver?
> 
> Depends which mechanisms and who's interested in doing any work on it.

Yes, we're interested in porting to cfg80211 and I definitely see that
in the future.

Dan


