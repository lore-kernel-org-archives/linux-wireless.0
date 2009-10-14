Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:42328 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbZJNGhO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 02:37:14 -0400
Received: by iwn10 with SMTP id 10so3213381iwn.4
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2009 23:36:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87hbu2o5fa.fsf@purkki.valot.fi>
References: <20091013173313.13021.80289.stgit@tikku> <646765f40910131533hccd7403jf3e4a66074dd7143@mail.gmail.com>
	<87hbu2o5fa.fsf@purkki.valot.fi>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 14 Oct 2009 16:36:18 +1000
Message-ID: <646765f40910132336m75799f8asb4328456f0f2e921@mail.gmail.com>
Subject: Re: [PATCH 1/2] mac80211: add ieee80211_rx_ni()
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 14, 2009 at 16:28, Kalle Valo <kalle.valo@iki.fi> wrote:
> Julian Calaby <julian.calaby@gmail.com> writes:
>
>>> - * Calls to this function and ieee80211_rx() may not be mixed for a
>>> - * single hardware.
>>> + * Calls to this function, ieee80211_rx() or ieee80211_rx_ni() may not
>>> + * be mixed for a single hardware.
>>
>> You missed out ieee80211_rx_irqsafe() here.
>
> Here "this function" refer to ieee80211_rx_irqsafe(). But I can also
> write it like this:
>
>  Calls to ieee80211_rx_irqsafe(), ieee80211_rx() or ieee80211_rx_ni()
>  may not be mixed for a single hardware.
>
> Is that any better?

Smacks self upside the head.

This is what I get for commenting on patches in the morning.

Sorry for the noise.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
