Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:55714 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755612AbYG3TvF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 15:51:05 -0400
Subject: Re: Issue: iwlist scanning sees the network; dhclient can't connect
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: "Thiago F. Tavares" <ttavares@halogica.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200807302141.07738.mb@bu3sch.de>
References: <1127857B97C63B4285A9B02BEF67AEE601627648@afrodite.halogica.com.br>
	 <1217446602.25919.5.camel@dv>  <200807302141.07738.mb@bu3sch.de>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 15:51:03 -0400
Message-Id: <1217447463.25919.10.camel@dv> (sfid-20080730_215124_120619_94F43935)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-07-30 at 21:41 +0200, Michael Buesch wrote:

> dhclient works fine for me. Although it's true that it sometimes
> messes with up/down state. But you _can_ use it, if you take some care.

True.  But b43 has the lowest dhclient survival rate of all drivers I
know.  That's an empirical observation, of course.

-- 
Regards,
Pavel Roskin
