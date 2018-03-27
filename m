Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:60536 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752347AbeC0NDa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 09:03:30 -0400
Message-ID: <1522155805.3050.11.camel@sipsolutions.net> (sfid-20180327_150334_109550_FD146D9E)
Subject: Re: [PATCH] mac80211: Fix wlan freezes under load at rekey
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Wetzel <alexander.wetzel@web.de>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Mar 2018 15:03:25 +0200
In-Reply-To: <313d0742-2b61-40cd-4b41-7fe263221321@web.de>
References: <20180324102921.9814-1-alexander.wetzel@web.de>
         <7bbb4246-324e-1d6d-245f-2642badb034d@candelatech.com>
         <27aca99e-a521-be4a-9fd4-51c557f9777d@web.de>
         <3e433bd6-d13e-f71c-d3ff-7163c2b59226@candelatech.com>
         <692de5e6-24d8-e1fe-c345-2ba3df91c9da@dd-wrt.com>
         <313d0742-2b61-40cd-4b41-7fe263221321@web.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-03-26 at 22:24 +0200, Alexander Wetzel wrote:

> There are quite many interesting things visible here, not the least one
> that ath9k leaks unencrypted frames for both patched and unpatched
> mac80211 which at least for my patched variant probably allow to
> calculate the TK key and encrypt all frames.

That's odd - any thoughts on how that might be happening?


johannes
