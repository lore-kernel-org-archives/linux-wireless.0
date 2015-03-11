Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:4717 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbbCKVbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 17:31:09 -0400
Message-ID: <5500B417.9070307@broadcom.com> (sfid-20150311_223115_786657_9692578E)
Date: Wed, 11 Mar 2015 22:31:03 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mac80211-hwsim and tx-rates.
References: <5500AEAB.8010605@candelatech.com>
In-Reply-To: <5500AEAB.8010605@candelatech.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/11/15 22:07, Ben Greear wrote:
> When using the user-space transport, the netlink frame sent to user-space
> has a rate index and retry count, and nothing else.  Is there a
> reliable way to know in user-space what index maps to what actual rate?

Not sure what you are exactly looking for, but maybe the function 
cfg80211_calculate_bitrate() in net/wireless/util.c may provide you some 
answers.

Regards,
Arend

> If not, any suggestions for how to improve this?  Maybe add
> a new object that passes up a bunch more info about the actual
> rates instead of just the rate idx?
>
> Thanks,
> Ben
>

