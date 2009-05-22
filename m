Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47759 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbZEVKP0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 06:15:26 -0400
Received: by fxm2 with SMTP id 2so1557097fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 22 May 2009 03:15:26 -0700 (PDT)
To: "ffileppo" <ffileppo@libero.it>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Re: mac80211: TDMA approach feasible?
References: <KK1J00$BAC7E4518757B17D1805E790669D6D1D@libero.it>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 22 May 2009 13:15:24 +0300
In-Reply-To: <KK1J00$BAC7E4518757B17D1805E790669D6D1D@libero.it> (ffileppo@libero.it's message of "Fri\, 22 May 2009 12\:12\:00 +0200")
Message-ID: <87skixv3yb.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"ffileppo" <ffileppo@libero.it> writes:

>  
>> > I was wondering if with mac80211 is now possible (and what effort
>> > is needed) to implement a TDMA approach. In particular I would
>> > like to: override 802.11 MPDU frame format, eliminate RTS/CTS
>> > exchange, eliminate automatic ACK and retransmission, eliminate
>> > virtual carrier sense (NAV), control PHY clear channel assessment
>> > and control transmission backoff.
>>  Most of this is usually implemented in firmware, so you need access
>> to firmware sources.
>
> If these features are implemented in firmware, it should be possible
> to modify them if using for example Ath5k (which is a completely FOSS
> Linux driver) Right? Could you give me any directions?

Sorry, I'm not familiar with ath5k.

-- 
Kalle Valo
