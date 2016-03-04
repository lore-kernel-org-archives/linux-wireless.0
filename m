Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37543 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbcCDOic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 09:38:32 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: arend@broadcom.com, linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V11 1/2] nl80211: add feature for BSS selection support
References: <1456947439-28968-1-git-send-email-arend@broadcom.com>
	<1457020529.2044.31.camel@sipsolutions.net>
	<56D8A618.4050707@broadcom.com>
	<1457082805.2333.0.camel@sipsolutions.net>
Date: Fri, 04 Mar 2016 16:38:27 +0200
In-Reply-To: <1457082805.2333.0.camel@sipsolutions.net> (Johannes Berg's
	message of "Fri, 04 Mar 2016 10:13:25 +0100")
Message-ID: <87r3fql34s.fsf@purkki.adurom.net> (sfid-20160304_153835_863067_E89C3A01)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2016-03-03 at 22:01 +0100, Arend Van Spriel wrote:
>> 
>> On 3-3-2016 16:55, Johannes Berg wrote:
>> > On Wed, 2016-03-02 at 20:37 +0100, Arend van Spriel wrote:
>> > > Introducing a new feature that the driver can use to
>> > > indicate the driver/firmware supports configuration of BSS
>> > > selection criteria upon CONNECT command. This can be useful
>> > > when multiple BSS-es are found belonging to the same ESS,
>> > > ie. Infra-BSS with same SSID. The criteria can then be used to
>> > > offload selection of a preferred BSS.
>> > > 
>> > Applied, finally :)
>> > 
>> > I moved the wiphy supported methods check into parse_bss_select()
>> > to
>> > avoid the double error path in the caller, plus some editorial
>> > changes.
>> 
>> Do you expect Kalle to take the brcmfmac patch or can it go through
>> your tree?
>> 
>
> I was expecting Kalle to apply it.

Ack, you assigned it to me so it's on my queue now:

https://patchwork.kernel.org/patch/8484901/

-- 
Kalle Valo
