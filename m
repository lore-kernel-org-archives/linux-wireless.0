Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:40076 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbYGaNc3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 09:32:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Issue: iwlist scanning sees the network; dhclient can't connect
Date: Thu, 31 Jul 2008 15:31:54 +0200
Cc: Pavel Roskin <proski@gnu.org>,
	"Thiago F. Tavares" <ttavares@halogica.com>,
	linux-wireless@vger.kernel.org
References: <1127857B97C63B4285A9B02BEF67AEE601627648@afrodite.halogica.com.br> <1217447463.25919.10.camel@dv> <1217493665.3392.0.camel@Friederike-PC.hoffi>
In-Reply-To: <1217493665.3392.0.camel@Friederike-PC.hoffi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807311531.54665.mb@bu3sch.de> (sfid-20080731_153232_597492_F811B8D2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 31 July 2008 10:41:05 Johannes Berg wrote:
> On Wed, 2008-07-30 at 15:51 -0400, Pavel Roskin wrote:
> > On Wed, 2008-07-30 at 21:41 +0200, Michael Buesch wrote:
> > 
> > > dhclient works fine for me. Although it's true that it sometimes
> > > messes with up/down state. But you _can_ use it, if you take some care.
> > 
> > True.  But b43 has the lowest dhclient survival rate of all drivers I
> > know.  That's an empirical observation, of course.
> 
> I think debian patches out the down/up behaviour. We may be seeing that.

Oh, that might explain why I don't see this behaviour.


-- 
Greetings Michael.
