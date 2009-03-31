Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41084 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZCaMJB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 08:09:01 -0400
Received: by fxm2 with SMTP id 2so2400794fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2009 05:08:58 -0700 (PDT)
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: Sujith <Sujith.Manoharan@atheros.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Jouni.Malinen@atheros.com,
	Luis.Rodriguez@atheros.com
Subject: Re: [PATCH 11/17] ath9k: Remove TIM from the interrupt mask
References: <18896.38867.997551.983464@gargle.gargle.HOWL>
	<8763hqnccb.fsf@litku.valot.fi>
	<8e92b4100903302322t531f5badt84fab14eeab943ff@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 31 Mar 2009 15:08:56 +0300
In-Reply-To: <8e92b4100903302322t531f5badt84fab14eeab943ff@mail.gmail.com> (Vivek Natarajan's message of "Tue\, 31 Mar 2009 11\:52\:15 +0530")
Message-ID: <87eiwdsxlz.fsf@litku.valot.fi> (sfid-20090331_140906_499299_8F854716)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vivek.natraj@gmail.com> writes:

>> This might be useful for beacon filtering. Does the hardware know to
>> parse the beacons in more detail, for example ERP protection or WMM
>> settings?
>
> After a quick glance into the datasheet, I understand that the
> current version of hardware supports reading TIM, TSF and some more
> bits related to DTIM from a beacon.

Is the datasheet available somewhere?

> As far as this patch is concerned, since ath9k can use mac80211 for
> sending a null data frame, it is quite redundant to enable the TIM
> interrupt as it can be parsed in mac80211 itself.

Sure. But I was thinking the possibility of having beacon filtering in
ath9k and then mac80211 wouldn't receive the beacons.

-- 
Kalle Valo
