Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35195 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750992AbeAXFOk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 00:14:40 -0500
Received: by mail-wm0-f43.google.com with SMTP id r78so6054040wme.0
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jan 2018 21:14:39 -0800 (PST)
Date: Wed, 24 Jan 2018 06:14:35 +0100 (CET)
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
In-Reply-To: <20180123132234.GC2520@redhat.com>
Message-ID: <alpine.LNX.2.21.99.1801240611330.5363@mStation.localdomain> (sfid-20180124_061449_445226_5310B55A)
References: <20171219122707.GA2672@redhat.com> <alpine.LNX.2.21.99.1712191341570.2555@localhost.localdomain> <20171219125431.GB2672@redhat.com> <alpine.LNX.2.21.99.1712201848250.21776@localhost.localdomain> <20171221142558.GB4655@redhat.com>
 <alpine.LNX.2.21.99.1712241311370.28605@localhost.localdomain> <20180103113540.GA10306@redhat.com> <alpine.LNX.2.21.99.1801031503370.8405@localhost.localdomain> <CAKR_QVLRwAA0NJSarX46J4A8XSp8h5SuTEtSBQ4ydpEPh_-aUw@mail.gmail.com>
 <alpine.LNX.2.21.99.1801220643400.32225@mStation.localdomain> <20180123132234.GC2520@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

good morning!

First of all - thank you very much for your help and patience: it's not common to find kind people, and people that cares to help with some older hardware (in my case).

So, regarding the WL-330N3G, I think you are right. And after all, thinking about it, my previous reasoning isn't so plausible, sorry.

Regarding the firmware, in my specific case it seems OpenWRT extracts calibration data from the flash, but doesn't upload a firmware to the device.
I'll look closely when the device is in a more reachable state.
I may well be wrong.
Thank you again for all Stanislav, Tom for helping out in reporting.
And in general, all of you.
Enrico
