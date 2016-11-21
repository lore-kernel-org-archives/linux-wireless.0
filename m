Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58508 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753817AbcKUQgV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 11:36:21 -0500
Date: Mon, 21 Nov 2016 21:58:20 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Break-it testing for wifi
Message-ID: <20161121162820.GA31693@atheros-ThinkPad-T61> (sfid-20161121_173633_715987_B722D57A)
References: <a60dac22-655e-ea93-61c2-73db05a47572@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a60dac22-655e-ea93-61c2-73db05a47572@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

just googled out 'wifi fuzzy testing' and found something relevant
as below
https://www.blackhat.com/presentations/bh-europe-07/Butti/Presentation/bh-eu-07-Butti.pdf

regards,
shafi

On Mon, Nov 21, 2016 at 08:10:37AM -0800, Ben Greear wrote:
> Hello!
> 
> I am thinking about adding some sort of framework to wpa_supplicant and/or the
> mac80211 stack to allow purposefully creating bad station behaviour in order to
> test robustness of APs.
> 
> Some ideas so far:
> 
> 1)  Allow supplicant to do bad state-machine transitions (start 4-way before associating, for instance).
> 
> 2)  Randomly corrupt mgt frames in driver and/or mac80211 stack and/or supplicant.
> 
> 3)  Possibly allow user to make specific corruptions.  This would probably be in supplicant
>     only, and I am not sure how this would be configured.  Maybe allow user to over-ride
>     existing IEs and add bogus ones of their own choosing.
> 
> 4)  Maybe some specific tests like putting in over-flow sized lengths of IEs.
> 
> Has anyone done anything similar they would like to share?
> 
> Johannes:  Any interest in having such a framework in upstream kernels?
> 
> Any other ideas for how to improve this feature set?
> 
> Thanks,
> Ben
> 
> -- 
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
> 
