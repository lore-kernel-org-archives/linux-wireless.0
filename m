Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37986 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751159AbdESLvJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 07:51:09 -0400
Message-ID: <1495194667.3274.12.camel@sipsolutions.net> (sfid-20170519_135115_247260_C699F52A)
Subject: Re: [PATCH 5/7] mac80211: add wide bandwidth channel switch
 announcement to CSA action frames and mesh beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: linux-wireless@vger.kernel.org, benjamin@sipsolutions.net
Date: Fri, 19 May 2017 13:51:07 +0200
In-Reply-To: <2485332.tTJvvc4NYf@prime> (sfid-20170519_134524_648562_8F06EDD8)
References: <20170516092316.15636-1-sw@simonwunderlich.de>
         <20170516092316.15636-6-sw@simonwunderlich.de>
         <1495193617.3274.7.camel@sipsolutions.net> <2485332.tTJvvc4NYf@prime>
         (sfid-20170519_134524_648562_8F06EDD8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> The spec says I need it, and if I understood the parsing function
> correctly it will only search for the wide bw IE when it finds the
> wrapper.

Yeah, I think there's some difference between action frames and beacons
though. You're only building the beacon here, so I think this is right.

johannes
