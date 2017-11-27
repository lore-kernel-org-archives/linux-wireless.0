Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:38040 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751712AbdK0Lz5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Nov 2017 06:55:57 -0500
Message-ID: <1511783754.5456.7.camel@sipsolutions.net> (sfid-20171127_125600_505346_83F6454F)
Subject: Re: What would it take to get WDS working with channel contexts?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 27 Nov 2017 12:55:54 +0100
In-Reply-To: <6c0f3696-b4bb-d653-3661-35250fae2894@candelatech.com>
References: <24f85baf-5e19-a2c9-517d-9b69a47860d9@candelatech.com>
         <1510911915.2030.37.camel@sipsolutions.net>
         <6c0f3696-b4bb-d653-3661-35250fae2894@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-11-17 at 08:46 -0800, Ben Greear wrote:

> It looks like my options are to hack the mac80211 stack to be minimally
> functional with WDS and channel-contexts, or to hack ath10k driver to
> disable chan-tx in order to try to fix the ath10k firmware WDS issues.
> 
> I'd guess the former is of slightly more use to society.  Do you have
> any quick hacks to allow mac80211 to work with chantx and WDS, even
> if you wouldn't want them upstream?

No, I don't have anything like that, sorry.

johannes
