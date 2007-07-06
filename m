Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp166.iad.emailsrvr.com ([207.97.245.166]:46791 "EHLO
	smtp166.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbXGFNwG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 09:52:06 -0400
Message-ID: <468E48AF.10109@gentoo.org>
Date: Fri, 06 Jul 2007 09:50:39 -0400
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Andy Green <andy@warmcat.com>
CC: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: Arrested Development
References: <468DE699.9040708@warmcat.com>
In-Reply-To: <468DE699.9040708@warmcat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Green wrote:
> Second is a small patch for zd1211rw-mac80211 that fixes rate reporting
> on radiotap rx, last sent here 11 June.
> 
> http://www.spinics.net/lists/linux-wireless/msg02897.html

Oh and if you want to jump on ahead and save me some time, answering 
these questions might help :)

Why isn't this needed for the softmac driver? (or is it broken there too?)

Are we really sure we need another rate conversion function? there are 
already a couple in the mac80211 driver, and one or 2 extra (for RTS/CTS 
rate programming) in the softmac driver.

Daniel
