Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab2DAS4L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Apr 2012 14:56:11 -0400
Date: Sun, 1 Apr 2012 18:52:31 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 3945ABG fails to connect (3.4-rc1)
Message-ID: <20120401165230.GA2399@redhat.com> (sfid-20120401_205615_236630_58DF62F7)
References: <20120401080419.GA5207@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120401080419.GA5207@comet.dominikbrodowski.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 01, 2012 at 10:04:19AM +0200, Dominik Brodowski wrote:
> Somewhere in between 3.3.0 and 3.4-rc1 my notebook fails to connect to my
> local AP:
> 
> 02:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection (rev 02)
> 
> Snippets from dmesg:
[snip]
> [   59.605953] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [   69.607344] wlan0: disassociating from $INSERT_MAC_HERE by local choice (reason=3)
> [   69.609931] cfg80211: Calling CRDA to update world regulatory domain
> [   69.612438] wlan0: deauthenticating from $INSERT_MAC_HERE by local choice (reason=3)
Most likely this is fixed by: 
http://marc.info/?l=linux-wireless&m=133180823427374&w=2

Plese test, thanks.
Stanislaw

