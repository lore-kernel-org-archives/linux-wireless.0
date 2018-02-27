Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60718 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751733AbeB0Qlw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 11:41:52 -0500
Subject: Re: fixed bit rate 9Mbps set as 24Mbps in g mode(legacy)
To: KAVITA MATHUR <kavitam@cdot.in>, ath10k@lists.infradead.org,
        backports@vger.kernel.org
References: <1519625792-12010-1-git-send-email-periyasa@codeaurora.org>
 <20180227083933.M59708@cdot.in>
Cc: linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <3047f184-d600-7be7-52bc-2ed4cee37ffe@candelatech.com> (sfid-20180227_174157_003541_EE3F9616)
Date: Tue, 27 Feb 2018 08:41:50 -0800
MIME-Version: 1.0
In-Reply-To: <20180227083933.M59708@cdot.in>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/2018 12:49 AM, KAVITA MATHUR wrote:
> Hi,
>
> I have configured AP in g mode and tested legacy rates.All basic rates and supported
> rates(1,2,5.5,11,6,9,12,18,24,36,48,54) are set except 9Mbps.
>
> When fixed bit rate 9Mbps is set, it gets set as 24 Mbps. This issue has been observed
> in backports-4.4.2-1 as well as latest git version of ath10k driver.
>
>
> Is anybody aware of this issue? How can I fix this rate 9Mbps?

You should specify which firmware/chipset you are using, since this might
easily be a firmware issue.

And, how are you determining that 'it gets set to 24Mbps'.  Is that the encoding
you see in a wifi sniff, or is the driver being set to 24Mbps improperly when
you use iw (or whatever) to try configuring the rate?

Recent upstream mac80211 has broken the ability to set a single tx rate as well,
last I checked.

Thanks,
Ben

>
>
> Thanks & Regards,
> Kavita
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe backports" in
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
