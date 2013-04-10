Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:43077 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935291Ab3DJXi1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 19:38:27 -0400
Received: by mail-we0-f175.google.com with SMTP id t11so798970wey.6
        for <linux-wireless@vger.kernel.org>; Wed, 10 Apr 2013 16:38:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5165F6A4.9060305@net.t-labs.tu-berlin.de>
References: <5165E1C2.4020407@net.t-labs.tu-berlin.de>
	<CAJ-Vmo=boxae6Cs+yDerTCGOa=rq-dZeNLeTjGjroBMxwsfU4A@mail.gmail.com>
	<5165F6A4.9060305@net.t-labs.tu-berlin.de>
Date: Wed, 10 Apr 2013 16:38:25 -0700
Message-ID: <CAJ-VmonsVVvOPBEyEUFn_BuuAvecQXgjfStmqoeFLpCPzUJhVQ@mail.gmail.com> (sfid-20130411_013838_675668_FCC32257)
Subject: Re: [RFC] ath9k: Respect current txpower setting
From: Adrian Chadd <adrian@freebsd.org>
To: Tobias Steinicke <tobias.steinicke@net.t-labs.tu-berlin.de>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If TPC isn't enabled, the cards transmit at the power configured in
the AR_PHY_TX_POWER_* registers.



Adrian
