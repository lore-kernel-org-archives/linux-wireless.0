Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50194 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932346AbcLMPSg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 10:18:36 -0500
Message-ID: <1481642312.20412.3.camel@sipsolutions.net> (sfid-20161213_161855_606456_A829589F)
Subject: Re: [PATCH v2 2/2] net: rfkill: Add rfkill-any LED trigger
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Micha=C5=82_K=C4=99pie=C5=84?= <kernel@kempniu.pl>,
        "David S . Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 13 Dec 2016 16:18:32 +0100
In-Reply-To: <20161208073052.12988-2-kernel@kempniu.pl> (sfid-20161208_083102_765888_8AC6C6B6)
References: <20161208073052.12988-1-kernel@kempniu.pl>
         <20161208073052.12988-2-kernel@kempniu.pl>
         (sfid-20161208_083102_765888_8AC6C6B6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-12-08 at 08:30 +0100, Michał Kępień wrote:
> Add a new "global" (i.e. not per-rfkill device) LED trigger, rfkill-
> any,
> which may be useful on laptops with a single "radio LED" and multiple
> radio transmitters.  The trigger is meant to turn a LED on whenever
> there is at least one radio transmitter active and turn it off
> otherwise.
> 

Also applied, but I moved the discussion of the mutex into the recorded
commit log.

johannes
