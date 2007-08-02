Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50693
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761300AbXHBVGk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 17:06:40 -0400
From: Michael Buesch <mb@bu3sch.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC 0/10] Port of bcm43xx from softmac to mac80211
Date: Thu, 2 Aug 2007 23:06:33 +0200
Cc: Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	jbenc@suse.cz, flamingice@sourmilk.net
References: <46b1fde0.b+weBDN75J0SPe2a%Larry.Finger@lwfinger.net> <46B20695.2080100@lwfinger.net> <1186088678.2931.10.camel@pmac.infradead.org>
In-Reply-To: <1186088678.2931.10.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708022306.34139.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 02 August 2007, David Woodhouse wrote:
> On Thu, 2007-08-02 at 11:30 -0500, Larry Finger wrote:
> > I was hoping this would be your response, but I had to make the
> > effort. I'll wait for a couple of days to see if anyone else has any
> > comments and send it on to Linville and hope it ends up in -mm  fairly
> > soon. It _DOES_ work on the hardware.
> 
> My experience is that mac80211 is broken w.r.t IPv6 -- it receives its
> own packets. It would be suboptimal for me if the softmac version of
> bcm43xx were to go away before that got fixed.
> 

We don't go _away_ from anything until there's no regression anymore.
This is a patchset which adds a driver. It does not remove something.

