Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43202 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbYGaGmD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 02:42:03 -0400
Subject: Re: Issue: iwlist scanning sees the network; dhclient can't connect
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Michael Buesch <mb@bu3sch.de>,
	"Thiago F. Tavares" <ttavares@halogica.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1217447463.25919.10.camel@dv> (sfid-20080730_215124_120619_94F43935)
References: <1127857B97C63B4285A9B02BEF67AEE601627648@afrodite.halogica.com.br>
	 <1217446602.25919.5.camel@dv>  <200807302141.07738.mb@bu3sch.de>
	 <1217447463.25919.10.camel@dv> (sfid-20080730_215124_120619_94F43935)
Content-Type: text/plain
Date: Thu, 31 Jul 2008 09:41:05 +0100
Message-Id: <1217493665.3392.0.camel@Friederike-PC.hoffi> (sfid-20080731_084209_611359_C5D21713)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-07-30 at 15:51 -0400, Pavel Roskin wrote:
> On Wed, 2008-07-30 at 21:41 +0200, Michael Buesch wrote:
> 
> > dhclient works fine for me. Although it's true that it sometimes
> > messes with up/down state. But you _can_ use it, if you take some care.
> 
> True.  But b43 has the lowest dhclient survival rate of all drivers I
> know.  That's an empirical observation, of course.

I think debian patches out the down/up behaviour. We may be seeing that.

johannes

