Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60140 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936843AbdAFNAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 08:00:05 -0500
Message-ID: <1483707597.12677.0.camel@sipsolutions.net> (sfid-20170106_140112_610579_481F5847)
Subject: Re: [PATCH V6 1/3] dt-bindings: document common IEEE 802.11
 frequency limit property
From: Johannes Berg <johannes@sipsolutions.net>
To: Rob Herring <robh+dt@kernel.org>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Date: Fri, 06 Jan 2017 13:59:57 +0100
In-Reply-To: <CAL_JsqKYpTZFRJpPR1V9MmA-JW5ntoKzbkjwnYBp9HMWLObG3A@mail.gmail.com>
References: <20170104175832.25996-1-zajec5@gmail.com>
         <CAL_JsqLg5YkC-YUHg6mQ35nmGaG7SC33VJB++fgtZsu1fRV-7Q@mail.gmail.com>
         <1483617089.4394.13.camel@sipsolutions.net>
         <CAL_JsqKYpTZFRJpPR1V9MmA-JW5ntoKzbkjwnYBp9HMWLObG3A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-01-05 at 10:34 -0600, Rob Herring wrote:
> On Thu, Jan 5, 2017 at 5:51 AM, Johannes Berg <johannes@sipsolutions.
> net> wrote:
> > 
> > > Acked-by: Rob Herring <robh@kernel.org>
> > 
> > Do I take that to mean that we'll merge it through the subsystem
> > tree,
> > and not go through some common DT tree?
> 
> Yes, that's generally the case when bindings are in a series with
> driver changes.

Alright, thanks.

I've applied patches 1-3, patch 4 obviously still needs work (and
probably won't go through my tree anyway.)

Note that I made some documentation fixes in patch 3, Rafał, please
check.

johannes
