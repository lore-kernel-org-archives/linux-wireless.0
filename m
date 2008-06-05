Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:51574 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbYFEVuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 17:50:08 -0400
Received: by rv-out-0506.google.com with SMTP id l9so1001371rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2008 14:50:08 -0700 (PDT)
Message-ID: <b6c5339f0806051450i47b5d874y86398cec61675ce6@mail.gmail.com> (sfid-20080605_235013_870625_747D036A)
Date: Thu, 5 Jun 2008 17:50:08 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Zack Weinberg" <zackw@panix.com>
Subject: Re: Getting ath5k driver working with Thinkpad T61 [168c:1014]
Cc: "Nick Kossifidis" <mickflemm@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <eb97335b0806031445l4f2061ccue65ae54ef5a540bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <eb97335b0805141024w6afa864j860b312b072faa8a@mail.gmail.com>
	 <40f31dec0805151750w7d1c8654jae7bc20064cbb16e@mail.gmail.com>
	 <eb97335b0806031445l4f2061ccue65ae54ef5a540bf@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 3, 2008 at 5:45 PM, Zack Weinberg <zackw@panix.com> wrote:
> I'm sorry to have taken so long to get back to y'all.  It turns out I
> was wrong about madwifi, it does work with this chipset.

Great!

> Since it works now with madwifi, I am attaching mmiotrace runs for
> ath5k (latest compat-wireless driver, which still doesn't work) and
> madwifi.

Any changes in the dmesg output when you use ath5k?  I looked very briefly and
didn't see the usual symptom of a locked up card (reads of 0xffffffff), but it
also looks like there is only .08 seconds covered by the trace.  Could you try
another trace for a bit longer?

> Please let me know if you still want to see traces for the
> windows driver.  (The madwifi trace also includes a successful "iwlist
> wlan0 scan" operation; the ath5k trace obviously does not.)

Probably not necessary -- the madwifi trace looks fine.

Thanks!
-- 
Bob Copeland %% www.bobcopeland.com
