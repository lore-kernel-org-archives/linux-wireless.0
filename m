Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9296 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762822AbdLSMzU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 07:55:20 -0500
Date: Tue, 19 Dec 2017 13:54:32 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Enrico Mioso <mrkiko.rs@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        nbd@nbd.name
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
Message-ID: <20171219125431.GB2672@redhat.com> (sfid-20171219_135524_189362_E3C442E6)
References: <alpine.LNX.2.21.99.1712112132480.7817@localhost.localdomain>
 <20171213152017.GA3554@redhat.com>
 <alpine.LNX.2.21.99.1712161924030.11214@localhost.localdomain>
 <20171218152142.GA15414@redhat.com>
 <20171219122707.GA2672@redhat.com>
 <alpine.LNX.2.21.99.1712191341570.2555@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LNX.2.21.99.1712191341570.2555@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 19, 2017 at 01:43:11PM +0100, Enrico Mioso wrote:
> I am going to test this on a LEDE build.
> Should I leave the mmio workaround patch applied as per OpenWRT default, or should I leave it off ?
> I'll leave it off by default.

Please remove it. If things would work then retest with it and see if
if things still work.

Thanks
Stanislaw
