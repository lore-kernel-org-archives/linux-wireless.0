Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:44439 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752969AbXDVWYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2007 18:24:11 -0400
Message-ID: <462BE085.1050906@lwfinger.net>
Date: Sun, 22 Apr 2007 17:24:05 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Pavel Roskin <proski@gnu.org>,
	John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ieee80211: Output frequency rather than channel in scan  results
References: <46298e00.m7oDqYNvDCFdCSj1%Larry.Finger@lwfinger.net>	 <20070421001253.q449myskosg0sg8k@webmail.spamcop.net>	 <1177193997.19554.1.camel@localhost.localdomain>	 <462A965D.9000708@lwfinger.net> <1177279412.21205.23.camel@localhost.localdomain>
In-Reply-To: <1177279412.21205.23.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> 
> Haha.  Ok.  NM should be smarter about this and convert channels
> returned by the driver into frequencies.  In the end, I prefer
> frequencies where at all possible, because channel numbers are _not_
> unique (unless you use the the tuple of [standard, band, channel] where
> standard is something like "802.11" or "802.16", band is "a" or "bg").

My current (but not yet accepted) patch for ieee80211 outputs both channel and frequency as does the 
"soon to be submitted" one for mac80211. I agree that frequency is unique; however, I find it easier 
to think in terms of channels. In addition, I only use the bg band and have no confusion. If both 
are listed, everyone should be happy.

Larry
