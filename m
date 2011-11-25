Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:46323 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab1KYHAx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 02:00:53 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwl3945 firmware errors: tentative debugging
References: <CAJZjf_xDm_RaFqxF-r+MAPyh_HcCb+yV4dNrfhr+LH0-z2zk8g@mail.gmail.com>
	<CAJZjf_yEBb3BEf+-Fei78xBmJT1Y_Jr5fPUJNKwi6kvuVg24KA@mail.gmail.com>
Date: Fri, 25 Nov 2011 09:00:45 +0200
In-Reply-To: <CAJZjf_yEBb3BEf+-Fei78xBmJT1Y_Jr5fPUJNKwi6kvuVg24KA@mail.gmail.com>
	(Pedro Francisco's message of "Thu, 24 Nov 2011 11:49:30 +0000")
Message-ID: <87bos0hejm.fsf@purkki.adurom.net> (sfid-20111125_080057_181858_B803C4C1)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pedro Francisco <pedrogfrancisco@gmail.com> writes:

> iwl3945 has had firmware errors triggered 'by' NM after started using
> nl80211 instead of wext. Since Intel has stopped supporting iwl3945,
> no firmware fix has been possible. It has been workarounded by
> disable_hw_scan=1 as default, with the penalty of network performance
> being lower and frequent 'hangs' on the connection.
>
> I was able to trigger the firmware error by doing "iw dev wlan0 scan
> passive". By comparison, "iw dev wlan0 scan" does NOT trigger the
> firmware error.

So NM uses passive scan? Now I'm curious, why is that?

-- 
Kalle Valo
