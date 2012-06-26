Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59624 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab2FZT0j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 15:26:39 -0400
Received: by weyu7 with SMTP id u7so189706wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 12:26:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20455.47109.203396.141311@gargle.gargle.HOWL>
References: <CAHD-aq+nNs4L0iZNxYSABX-1Wk+B=s-Avqc1TFYfO-8JOOZ5kA@mail.gmail.com>
 <20455.47109.203396.141311@gargle.gargle.HOWL>
From: Guido Iribarren <guidoiribarren@buenosaireslibre.org>
Date: Tue, 26 Jun 2012 16:26:17 -0300
Message-ID: <CAHD-aqL9tW_rF3V0-_FX4erdyZE8vNYr+d=dShptRbePaXN_JQ@mail.gmail.com> (sfid-20120626_212644_163913_78CE9C21)
Subject: Re: Regression on ath9k_htc managed mode
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 24, 2012 at 9:59 PM, Sujith Manoharan
<c_manoha@qca.qualcomm.com> wrote:
> Guido Iribarren wrote:
>> Hello nice people,
>> we've recently found a bug when using infrastructure mode with tplink
>> wn722n usb dongles (ath9k_htc driver)
>
> Can you try this patch : http://tinyurl.com/7ywqzoz ?

Hello Sujith!
thanks for the patch, i found it strange because it seems related to
IBSS, but i just tried it anyway
unfortunately it didn't solve the problem :(

Please note the bug I described happens when in client (managed) mode,
and it is in fact a regression because it was working fine on 2012-02-27

something along the development up to 2012-04-13 caused the bug

In any case, thanks a lot for the help!
I'll be at your disposal to try other patches or reverts you consider
relevant, to further debug this down :)

Guido


>
> Sujith
