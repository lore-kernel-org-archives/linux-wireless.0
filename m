Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56017 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab2F1MVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 08:21:22 -0400
Received: by wgbdr13 with SMTP id dr13so2141296wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jun 2012 05:21:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20459.64903.329882.547190@gargle.gargle.HOWL>
References: <CAHD-aq+nNs4L0iZNxYSABX-1Wk+B=s-Avqc1TFYfO-8JOOZ5kA@mail.gmail.com>
	<20455.47109.203396.141311@gargle.gargle.HOWL>
	<CAHD-aqL9tW_rF3V0-_FX4erdyZE8vNYr+d=dShptRbePaXN_JQ@mail.gmail.com>
	<20459.64903.329882.547190@gargle.gargle.HOWL>
Date: Thu, 28 Jun 2012 09:21:21 -0300
Message-ID: <CAHD-aqJwbmmgL_RaoYerXwOh6Tyedrk+jKeoex0Xb5GCFxPnKQ@mail.gmail.com> (sfid-20120628_142125_599130_915D58DE)
Subject: Re: Regression on ath9k_htc managed mode
From: Guido Iribarren <guidoiribarren@buenosaireslibre.org>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, i'm doing the tests using the dongle connected to a tplink mr3220
running openwrt trunk for ar71xx.
The mr3220 has a usb port where i connect a tplink wn722n usb dongle.
The internal wifi of the router uses ath9k driver and works just fine.
The dongle uses ath9k_htc and presents the problem described, from the
moment openwrt devs upgraded trunk to use compat-wireless 2012-04-13

On 6/28/12, Sujith Manoharan <c_manoha@qca.qualcomm.com> wrote:
> Guido Iribarren wrote:
>> thanks for the patch, i found it strange because it seems related to
>> IBSS, but i just tried it anyway
>> unfortunately it didn't solve the problem :(
>>
>> Please note the bug I described happens when in client (managed) mode,
>> and it is in fact a regression because it was working fine on 2012-02-27
>>
>> something along the development up to 2012-04-13 caused the bug
>
> You had mentioned earlier that you were recompiling OpenWRT for bisecting,
> are you using an AP running OpenWRT ? On what platform is the dongle being
> used ?
>
> Sujith
>
