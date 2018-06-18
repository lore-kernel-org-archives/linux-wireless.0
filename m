Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:58312 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936286AbeFRUtb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 16:49:31 -0400
Message-ID: <1529354967.3092.43.camel@sipsolutions.net> (sfid-20180618_224943_979473_4B387212)
Subject: Re: [PATCH] ath10k: add dynamic vlan support
From: Johannes Berg <johannes@sipsolutions.net>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc: Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Date: Mon, 18 Jun 2018 22:49:27 +0200
In-Reply-To: <b94186ea-e76e-1940-365b-4ca72abad77f@dd-wrt.com>
References: <1524232653-22573-1-git-send-email-mpubbise@codeaurora.org>
         <87r2n5auvq.fsf@kamboji.qca.qualcomm.com>
         <aa04534d-9677-f42e-a239-b230093ef2f5@dd-wrt.com>
         <f8d6d13943ccac22f363d7d4f53d645c@codeaurora.org>
         <1526637270.3805.15.camel@sipsolutions.net>
         <59ff8201-fc1b-8579-d5a9-f4b08621f5ec@codeaurora.org>
         <1527069018.3759.15.camel@sipsolutions.net>
         <988f350d-a6eb-1733-4a2f-43a87053e96a@codeaurora.org>
         <1527071997.3759.18.camel@sipsolutions.net>
         <b94186ea-e76e-1940-365b-4ca72abad77f@dd-wrt.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-05-24 at 06:41 +0200, Sebastian Gottschall wrote:
> 
> mmh not sure. it might not check the capabilitiy, but it sets the 
> interface type to IFTYPE_AP_VLAN
> for wds sta interfaces. that might collide

That was my point - if it doesn't check the capability then we can
remove it without impacting backward compatibility, and add it back in
another bit saying "AP-VLAN for 4-addr only".

johannes
