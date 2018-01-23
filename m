Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42224 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752158AbeAWNWg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Jan 2018 08:22:36 -0500
Date: Tue, 23 Jan 2018 14:22:35 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Enrico Mioso <mrkiko.rs@gmail.com>
Cc: Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
Message-ID: <20180123132234.GC2520@redhat.com> (sfid-20180123_142320_127830_62F15A1D)
References: <20171219122707.GA2672@redhat.com>
 <alpine.LNX.2.21.99.1712191341570.2555@localhost.localdomain>
 <20171219125431.GB2672@redhat.com>
 <alpine.LNX.2.21.99.1712201848250.21776@localhost.localdomain>
 <20171221142558.GB4655@redhat.com>
 <alpine.LNX.2.21.99.1712241311370.28605@localhost.localdomain>
 <20180103113540.GA10306@redhat.com>
 <alpine.LNX.2.21.99.1801031503370.8405@localhost.localdomain>
 <CAKR_QVLRwAA0NJSarX46J4A8XSp8h5SuTEtSBQ4ydpEPh_-aUw@mail.gmail.com>
 <alpine.LNX.2.21.99.1801220643400.32225@mStation.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LNX.2.21.99.1801220643400.32225@mStation.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 22, 2018 at 06:45:57AM +0100, Enrico Mioso wrote:
> Crash happening here also in the WL-330n3G device; unfortunately, no messages to report.
> Regarding your hypothesis regardingthe firmware not being able to communicate a problem regarding it's inability to send frames: around when OpenWRT had 3.9.9 kernel, this device worked for weeks no stop with no issues I think.
> And I don't think this is only a coicnidence. So I suspect, but it's only an impression, also because I know ... very very little about this, that at some point things worked.

I think FW was upgraded since 3.9 kernel as well. But this 
could be also problem how driver program the device registers,
not only FW problem.

Regards
Stanislaw
