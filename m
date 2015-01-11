Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:42000 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbbAKNAX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2015 08:00:23 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so9853431wib.4
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jan 2015 05:00:21 -0800 (PST)
Message-ID: <54B273E1.6030306@googlemail.com> (sfid-20150111_140027_100097_B47C4919)
Date: Sun, 11 Jan 2015 13:00:17 +0000
From: Chris Clayton <chris2553@googlemail.com>
MIME-Version: 1.0
To: kvalo@codeaurora.org
CC: linux-wireless@vger.kernel.org
Subject: Re: IWLWIFI - 3.18-stable
References: <54B272F0.70307@googlemail.com>
In-Reply-To: <54B272F0.70307@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Doh! Cut and paste error ...

On 01/11/15 12:56, Chris Clayton wrote:
> Hi Kalle,
> 
> Having recently bought a new laptop, I've just started using the iwlwifi driver for wireless networking. I found both
> 3.18.x and the current development tree to be very unreliable due to frequent disconnections from the router.
> 
> Before you merged them into your tree, I grabbed the latest fixes from iwlwifi-fixes tree and applied them to the
> development kernel. Since I did that I've had no problems at all with dropped connections. I then looked at each patch
> to see whether it might be applicable to 3.18 and found that two of them looked as if they should be useful. They are:
> 
> c93edc639392df733c7d72db4376a9add775d18a - iwlwifi: mvm: don't allow diversity if BT Coex / TT forbid it

The above should have been:

c93edc639392df733c7d72db4376a9add775d18a - iwlwifi: mvm: fix Rx with both chains

> 
> a9dc5060bf3a32ac3dad472f15416054b92dc5b5 - iwlwifi: mvm: fix out of bounds access to tid_to_mac80211_ac
> 
> With those two applied, I've had stable wireless networking on 3.18.2 and, more recently, 3.18.2. Consequently, they
> seem appropriate for tagging for 3.18-stable, but, as far as I can see, they haven't been tagged for stable. Apologies,
> if I'm mistaken, but if I'm not, could you consider submitting the two patches for inclusion in 3.18, please? Of course,
> they may be appropriate to earlier kernels too - I haven't looked.
> 
> Thanks
> 
> Chris
> 
