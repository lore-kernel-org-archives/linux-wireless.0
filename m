Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbYGaUEN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 16:04:13 -0400
Subject: Re: Issue: iwlist scanning sees the network; dhclient can't connect
From: Dan Williams <dcbw@redhat.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Thiago F. Tavares" <ttavares@halogica.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1217516500.22143.3.camel@dv>
References: <1127857B97C63B4285A9B02BEF67AEE601627648@afrodite.halogica.com.br>
	 <1217447463.25919.10.camel@dv>
	 <1217493665.3392.0.camel@Friederike-PC.hoffi>
	 <200807311531.54665.mb@bu3sch.de>
	 <1217512159.12016.1.camel@localhost.localdomain>
	 <1217516500.22143.3.camel@dv>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 16:01:29 -0400
Message-Id: <1217534489.9377.15.camel@localhost.localdomain> (sfid-20080731_220416_463201_02042F5B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-07-31 at 11:01 -0400, Pavel Roskin wrote:
> On Thu, 2008-07-31 at 09:49 -0400, Dan Williams wrote:
> > We all agreed at the OLS Wireless Summit that the up/down behavior of
> > dhclient was just f**king stupid and should be patched out.  Upstream
> > doesn't seem to be very responsive.
> 
> Sorry for going offtopic, but somebody picked up dhcpcd, and it's in a
> pretty good shape now, preparing for 4.0 release.  It supports dhclient
> scripts, works with NetworkManager, and doesn't bring the interface
> down.  It even have a git repository, with the latest commit 79 made
> minutes ago.

Yeah, I'm aware of that.  But at the same time, there's a lot of
procedure, knowledge, integration, and custom scripts built up around
dhclient that isn't going to change overnight.

Dan

