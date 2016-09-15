Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:35774 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751111AbcION20 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 09:28:26 -0400
Received: by mail-it0-f50.google.com with SMTP id r192so94748256ita.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2016 06:28:25 -0700 (PDT)
Date: Thu, 15 Sep 2016 09:26:01 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: Using ath5k/ath9k radio for constant-tx noise source.
Message-ID: <20160915132601.GC4475@localhost> (sfid-20160915_152829_452233_02BCAEC1)
References: <55D4D406.5000603@candelatech.com>
 <55D5EE0E.3020408@neratec.com>
 <6d50965d-af35-dad9-23fe-162678a0f02f@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6d50965d-af35-dad9-23fe-162678a0f02f@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 14, 2016 at 05:22:46PM -0700, Ben Greear wrote:
> On 08/20/2015 08:11 AM, Zefir Kurtisi wrote:
> >On 08/19/2015 09:07 PM, Ben Greear wrote:
> >>I have a commercial AP that is using a CM9 ath5k radio (evidently, I could be wrong)
> >>and it has the ability to do a constant transmit of raw noise (RF probe shows
> >>noise, but a monitor-port sniffer does not see any frames from the CM9).
> >>
> >>I don't know the low-level details of how it is doing this, but I suspect
> >>it is using something like madwifi for a driver.
> >>
> >>Does anyone know how this can be done with modern software and
> >>ath5k or ath9k NICs?

Hi Ben,

I wrote some code to do this on ath5k -- I can post a patch if you're
interested in using ath5k for this.

Here's a snapshot of what it looks like when running on ch.1:

https://bobcopeland.com/images/speccy-testmode.png

-- 
Bob Copeland %% http://bobcopeland.com/
