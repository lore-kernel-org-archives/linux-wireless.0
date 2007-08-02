Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:56569 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754244AbXHBVb7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 17:31:59 -0400
Message-ID: <46B24D4D.5020904@lwfinger.net>
Date: Thu, 02 Aug 2007 16:31:57 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de, jbenc@suse.cz,
	flamingice@sourmilk.net
Subject: Re: [RFC 0/10] Port of bcm43xx from softmac to mac80211
References: <46b1fde0.b+weBDN75J0SPe2a%Larry.Finger@lwfinger.net>	 <200708021807.20649.mb@bu3sch.de>  <46B20695.2080100@lwfinger.net> <1186088678.2931.10.camel@pmac.infradead.org>
In-Reply-To: <1186088678.2931.10.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Woodhouse wrote:
> On Thu, 2007-08-02 at 11:30 -0500, Larry Finger wrote:
>> I was hoping this would be your response, but I had to make the
>> effort. I'll wait for a couple of days to see if anyone else has any
>> comments and send it on to Linville and hope it ends up in -mm  fairly
>> soon. It _DOES_ work on the hardware.
> 
> My experience is that mac80211 is broken w.r.t IPv6 -- it receives its
> own packets. It would be suboptimal for me if the softmac version of
> bcm43xx were to go away before that got fixed.
> 

This will go into -mm. I hope that it gets plenty of testing, in fact, I hope you grab the patch set 
and make a trial of your own. If this driver is broken with IPv6, I want to know.

Larry

