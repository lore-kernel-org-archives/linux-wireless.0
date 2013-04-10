Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:42220 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934556Ab3DJXcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 19:32:54 -0400
Message-ID: <5165F6A4.9060305@net.t-labs.tu-berlin.de> (sfid-20130411_013258_077144_ED6A1F5B)
Date: Thu, 11 Apr 2013 01:32:52 +0200
From: Tobias Steinicke <tobias.steinicke@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [RFC] ath9k: Respect current txpower setting
References: <5165E1C2.4020407@net.t-labs.tu-berlin.de> <CAJ-Vmo=boxae6Cs+yDerTCGOa=rq-dZeNLeTjGjroBMxwsfU4A@mail.gmail.com>
In-Reply-To: <CAJ-Vmo=boxae6Cs+yDerTCGOa=rq-dZeNLeTjGjroBMxwsfU4A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 11.04.2013 01:20, schrieb Adrian Chadd:
> On 10 April 2013 15:03, Tobias Steinicke
> <tobias.steinicke@net.t-labs.tu-berlin.de> wrote:
>> In routine ath_tx_fill_desc(), the txpower is only set to
>> MAX_RATE_POWER. Now it respects the txpower from bss_conf and set it if it
>> is (txpower * 2) < MAX_RATE_POWER else set to MAX_RATE_POWER.
> 
> This doesn't do anything unless TPC is enabled.

If I'm understanding this right, if TPC is disable the cards sending always
with the max. power (I guess from the current regdomain)?

Tobias
