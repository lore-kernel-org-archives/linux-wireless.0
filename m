Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:59832 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756991AbbGGOVg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 10:21:36 -0400
Received: from localhost (localhost [127.0.0.1])
	by arrakis.dune.hu (Postfix) with ESMTP id A5BAC28BE70
	for <linux-wireless@vger.kernel.org>; Tue,  7 Jul 2015 16:21:14 +0200 (CEST)
Received: from mail-qk0-f180.google.com (mail-qk0-f180.google.com [209.85.220.180])
	by arrakis.dune.hu (Postfix) with ESMTPSA id C5F11286F45
	for <linux-wireless@vger.kernel.org>; Tue,  7 Jul 2015 16:21:00 +0200 (CEST)
Received: by qkei195 with SMTP id i195so140678892qke.3
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jul 2015 07:21:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <82abdac15d6a469082af54661922f50c@SC-EXCH03.marvell.com>
References: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
 <CAOiHx=ncv=N33-CC-F0=_dovJ=PGsi3MBB3SEMg51fWcyuMmPg@mail.gmail.com>
 <e90aaab05cfd43fe9c05f738d4fc528a@SC-EXCH02.marvell.com> <CAOiHx=nnzfURJk6qeoyaV_qX0HPdtKSvZNmSNxKxypURMpNbkA@mail.gmail.com>
 <op.x1edl6b82s3iss@ecaz> <82abdac15d6a469082af54661922f50c@SC-EXCH03.marvell.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Tue, 7 Jul 2015 16:20:56 +0200
Message-ID: <CAOiHx==88xDNAbi1mKbM2+MCTCha+HLMJPzq4ovVfqu-Aym-jg@mail.gmail.com> (sfid-20150707_162205_052442_FD2CCC89)
Subject: Re: [PATCH v5] Add new mac80211 driver mwlwifi.
To: Chor Teck Law <ctlaw@marvell.com>
Cc: Imre Kaloz <kaloz@openwrt.org>, David Lin <dlin@marvell.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pete Hsieh <peteh@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 7, 2015 at 3:48 PM, Chor Teck Law <ctlaw@marvell.com> wrote:
>
>
>> -----Original Message-----
>> From: Imre Kaloz [mailto:kaloz@openwrt.org]
>> Sent: Tuesday, July 07, 2015 2:50 AM
>> To: David Lin; Jonas Gorski
>> Cc: Johannes Berg; linux-wireless@vger.kernel.org; Chor Teck Law; Pete
>> Hsieh
>> Subject: Re: [PATCH v5] Add new mac80211 driver mwlwifi.
>>
>> On Tue, 07 Jul 2015 11:38:32 +0200, Jonas Gorski <jogo@openwrt.org>
>> wrote:
>>
>> <snip>
>>
>> >>> I think it would be good to have some more precise description here
>> >>> (something like "Marvell 88W8864/8897 PCIe driver with AP
>> support").
>> >>>
>> >>
>> >> Will change the title from "Marvell Wireless Wi-Fi driver (mwlwifi)"
>> >> to "Marvell 88W8864/88W8897 PCIe driver with AP support".
>> >
>> > As Imre pointed out, mwifiex also supports AP mode, so this is not a
>> > good description.
>
> We have explained a few times on this... Pls read about the difference of mwifiex vs mwlwifi. There is a NOTE added to the description of KConfig of mwlwifi.
>
> Would the community prefer this description instead: "Marvell 88W8864/88W8897 driver with MAC80211 support"?

Let's keep the name as is and do a cleanup / naming discussion
seperate of that. This should not block the acceptance of the driver.


Jonas
