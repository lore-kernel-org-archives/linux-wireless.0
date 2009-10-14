Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:35720 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbZJNHUF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 03:20:05 -0400
Received: by fg-out-1718.google.com with SMTP id 16so1221926fgg.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2009 00:18:16 -0700 (PDT)
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: add ieee80211_rx_ni()
References: <20091013173313.13021.80289.stgit@tikku>
	<646765f40910131533hccd7403jf3e4a66074dd7143@mail.gmail.com>
	<87hbu2o5fa.fsf@purkki.valot.fi>
	<646765f40910132336m75799f8asb4328456f0f2e921@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 14 Oct 2009 10:18:14 +0300
In-Reply-To: <646765f40910132336m75799f8asb4328456f0f2e921@mail.gmail.com> (Julian Calaby's message of "Wed\, 14 Oct 2009 16\:36\:18 +1000")
Message-ID: <87d44qo349.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby <julian.calaby@gmail.com> writes:

>>> You missed out ieee80211_rx_irqsafe() here.
>>
>> Here "this function" refer to ieee80211_rx_irqsafe(). But I can also
>> write it like this:
>>
>>  Calls to ieee80211_rx_irqsafe(), ieee80211_rx() or ieee80211_rx_ni()
>>  may not be mixed for a single hardware.
>>
>> Is that any better?
>
> Smacks self upside the head.
>
> This is what I get for commenting on patches in the morning.
>
> Sorry for the noise.

No problem at all, thank you for the review.

-- 
Kalle Valo
