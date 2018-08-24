Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57438 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbeHXLsX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 07:48:23 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>
Subject: Re: [PATCH] ath10k: add dynamic vlan support
References: <1524232653-22573-1-git-send-email-mpubbise@codeaurora.org>
        <87r2n5auvq.fsf@kamboji.qca.qualcomm.com>
        <aa04534d-9677-f42e-a239-b230093ef2f5@dd-wrt.com>
        <f8d6d13943ccac22f363d7d4f53d645c@codeaurora.org>
        <1526637270.3805.15.camel@sipsolutions.net>
        <59ff8201-fc1b-8579-d5a9-f4b08621f5ec@codeaurora.org>
        <1527069018.3759.15.camel@sipsolutions.net>
        <eede64cf-ecf3-6697-a338-b7eb4c9bcd27@codeaurora.org>
        <1534408023.3547.64.camel@sipsolutions.net>
        <15ca06c2-0d43-99c1-8f31-19e73629ab70@codeaurora.org>
Date: Fri, 24 Aug 2018 11:14:46 +0300
In-Reply-To: <15ca06c2-0d43-99c1-8f31-19e73629ab70@codeaurora.org> (Manikanta
        Pubbisetty's message of "Fri, 24 Aug 2018 11:16:12 +0530")
Message-ID: <87va80ji4p.fsf@kamboji.qca.qualcomm.com> (sfid-20180824_101454_302368_DE0A8BA1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Manikanta Pubbisetty <mpubbise@codeaurora.org> writes:

> On 8/16/2018 1:57 PM, Johannes Berg wrote:
>
>     On Tue, 2018-08-14 at 18:23 +0530, Manikanta Pubbisetty wrote:
>
>             
>             I don't think that makes sense. If we split the capability of AP_VLAN
> and AP_VLAN_FOR_4ADDR at the "root", then we don't need to play with all
> these things. Yes, this is slightly awkward for userspace, and perhaps
> with the interface combination checks, but I'd like you to look at that.
>
>     
>     
>         I was working on splitting the 4-addr functionality from AP/VLAN iftype; 
> I have introduced a new iftype NL80211_IFTYPE_AP_4ADDR and moved the 
> 4-addr handling from AP/VLAN to this new iftype. But this approach 
> breaks the backward compatibility with older userspace applications. 
>
>     
> Yeah ...
>
> I'm confused and no longer sure what I was thinking, nor even what we're
> trying to achieve here...
>
> I had introduced a change db3bdcb9c3ff (" mac80211: allow AP_VLAN
> operation on crypto controlled devices ") for supporting VLAN
> functionality on ath10k devices; this commit has broken 4 addr support
> on ath10k devices as I was advertising the AP/VLAN support
> conditionally. Since 4 addr operation is tied to AP/VLAN support, with
> this change, only the chips which support VLAN functionality can
> support 4 addr operation but other ath10k chips don't.

Manikanta, please set up your Thunderbird so that it uses the standard
'>' quotation style. This mail is impossible to read as I don't know
which part is written by you and which part by Johannes.

-- 
Kalle Valo
