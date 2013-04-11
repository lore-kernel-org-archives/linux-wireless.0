Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:42244 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936571Ab3DKAE3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 20:04:29 -0400
Message-ID: <5165FE0B.6070009@net.t-labs.tu-berlin.de> (sfid-20130411_020432_519440_CA8FB91B)
Date: Thu, 11 Apr 2013 02:04:27 +0200
From: Tobias Steinicke <tobias.steinicke@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [RFC] ath9k: Respect current txpower setting
References: <5165E1C2.4020407@net.t-labs.tu-berlin.de> <CAJ-Vmo=boxae6Cs+yDerTCGOa=rq-dZeNLeTjGjroBMxwsfU4A@mail.gmail.com> <5165F6A4.9060305@net.t-labs.tu-berlin.de> <CAJ-VmonsVVvOPBEyEUFn_BuuAvecQXgjfStmqoeFLpCPzUJhVQ@mail.gmail.com>
In-Reply-To: <CAJ-VmonsVVvOPBEyEUFn_BuuAvecQXgjfStmqoeFLpCPzUJhVQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 11.04.2013 01:38, schrieb Adrian Chadd:
> If TPC isn't enabled, the cards transmit at the power configured in
> the AR_PHY_TX_POWER_* registers.

I understand. Thanks for the clarification.

But since TPC is enabled, we have to set info.txpower to the
right value. Also ar900[23]_set_txdesc() have to change to apply
info.txpower to all try series.

Tobias

