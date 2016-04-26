Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13944 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbcDZMDM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 08:03:12 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Ben Greear <greearb@candelatech.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: remove VHT capabilities from 2.4GHz
Date: Tue, 26 Apr 2016 12:03:03 +0000
Message-ID: <87mvogy3ux.fsf@kamboji.qca.qualcomm.com> (sfid-20160426_140316_531507_057BDEAC)
References: <1461244669-19871-1-git-send-email-kvalo@qca.qualcomm.com>
	<5718EE7A.4030503@candelatech.com>
	<1461654272.16188.4.camel@sipsolutions.net>
In-Reply-To: <1461654272.16188.4.camel@sipsolutions.net> (Johannes Berg's
	message of "Tue, 26 Apr 2016 09:04:32 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2016-04-21 at 08:15 -0700, Ben Greear wrote:
>
>> The thing is, it actually works just fine with the patch I posted
>> to fix mac80211, and at any rate, even if the mac80211 patch isn't
>> applied, the ath10k driver works just fine in HT mode.
>
> This patch has no implications on HT, and I wasn't planning on applying
> the mac80211 patch.

Yeah, makes sense. I'm planning to apply this soon.

> As I said, I have no objections to doing the (Broadcom) vendor specific
> IEs for "VHT" in 2.4 GHz band, but I don't think we should advertise
> the spec IEs when they're explicitly specified to be used only in the
> 5.2 GHz band.

But we really should have this, any volunteers? :) I think it shouldn't
be too hard to do so this would be a good project for someone looking
for a simple, but useful, task on wireless stack.

-- 
Kalle Valo