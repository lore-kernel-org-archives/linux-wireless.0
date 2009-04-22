Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:54299 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZDVFEW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 01:04:22 -0400
Received: by fxm2 with SMTP id 2so2888717fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 21 Apr 2009 22:04:21 -0700 (PDT)
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
References: <1239837672.11795.46.camel@violet>
	<1239875168.9737.10.camel@johannes.local>
	<1240247636.5260.11.camel@localhost.localdomain>
	<1240248008.4632.10.camel@johannes.local>
	<1240248385.5260.15.camel@localhost.localdomain>
	<1240248773.4632.13.camel@johannes.local>
	<1240343775.3327.3.camel@localhost.localdomain>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 22 Apr 2009 08:04:18 +0300
In-Reply-To: <1240343775.3327.3.camel@localhost.localdomain> (Marcel Holtmann's message of "Tue\, 21 Apr 2009 20\:56\:15 +0100")
Message-ID: <874owhffe5.fsf@litku.valot.fi> (sfid-20090422_070426_647642_CA604F51)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcel Holtmann <marcel@holtmann.org> writes:

> so I have built the latest wireless-testing tree with a new patches sent
> by Reinette fixing the DMA issue. So far I have no problems and I am
> unable to re-produce it. However this is a different AP and I disabled
> the power control feature for now.
>
> I also updated wpa_supplicant and iw to the latest code and assume that
> no fix in there silently fixed it for me.
>
> So we are suspecting that this issue was because of me having 3GB of RAM
> and running on a 64-bit kernel. Does this makes sense and could be the
> problem why it kept failing until I unload the iwlagn driver?

I would say that don't make any assumptions until you manage to test
with the original AP. APs can be broken so many ways.

-- 
Kalle Valo
