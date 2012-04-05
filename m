Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar-3.linta.de ([188.40.101.200]:45448 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753289Ab2DEJiT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 05:38:19 -0400
Date: Thu, 5 Apr 2012 11:38:02 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 3945ABG fails to connect (3.4-rc1)
Message-ID: <20120405093802.GA5236@comet.dominikbrodowski.net> (sfid-20120405_113822_368889_8C68F76D)
References: <20120401080419.GA5207@comet.dominikbrodowski.net>
 <20120401165230.GA2399@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120401165230.GA2399@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 01, 2012 at 06:52:31PM +0200, Stanislaw Gruszka wrote:
> On Sun, Apr 01, 2012 at 10:04:19AM +0200, Dominik Brodowski wrote:
> > Somewhere in between 3.3.0 and 3.4-rc1 my notebook fails to connect to my
> > local AP:
> > 
> > 02:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection (rev 02)
> > 
> > Snippets from dmesg:
> [snip]
> > [   59.605953] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> > [   69.607344] wlan0: disassociating from $INSERT_MAC_HERE by local choice (reason=3)
> > [   69.609931] cfg80211: Calling CRDA to update world regulatory domain
> > [   69.612438] wlan0: deauthenticating from $INSERT_MAC_HERE by local choice (reason=3)
> Most likely this is fixed by: 
> http://marc.info/?l=linux-wireless&m=133180823427374&w=2
> 
> Plese test, thanks.

Yes, this fixes it. Thanks!

	Dominik
