Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60474 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750757AbdLUO0B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 09:26:01 -0500
Date: Thu, 21 Dec 2017 15:25:59 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Enrico Mioso <mrkiko.rs@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        nbd@nbd.name
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
Message-ID: <20171221142558.GB4655@redhat.com> (sfid-20171221_152606_097949_5EA743A8)
References: <alpine.LNX.2.21.99.1712112132480.7817@localhost.localdomain>
 <20171213152017.GA3554@redhat.com>
 <alpine.LNX.2.21.99.1712161924030.11214@localhost.localdomain>
 <20171218152142.GA15414@redhat.com>
 <20171219122707.GA2672@redhat.com>
 <alpine.LNX.2.21.99.1712191341570.2555@localhost.localdomain>
 <20171219125431.GB2672@redhat.com>
 <alpine.LNX.2.21.99.1712201848250.21776@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LNX.2.21.99.1712201848250.21776@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 20, 2017 at 06:49:56PM +0100, Enrico Mioso wrote:
> Hello.
> First of all, thank you for your patience and work.
> Sorry if I am slow in testing, I am in a little bit of a complicated situation, and this is one of the reasons for why I am slow.
> With the two patches you sent me (thanks!), and removing the mmio workaround patch, I was not able to reproduce the errors. I plan to send you a precise response as soon as I am able to.
> thank you

No worries, we are not under deadline :-) You can just respond
to patches email with:

Tested-by: Enrico Mioso <mrkiko.rs@gmail.com>

tag. That will mean that you tested patches and that information will be
added to the commit changelog.

Regards
Stanislaw
