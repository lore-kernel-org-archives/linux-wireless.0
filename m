Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:45220 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaGPXGh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 19:06:37 -0400
Received: by mail-qg0-f43.google.com with SMTP id a108so1353855qge.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 16:06:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA2SeNJRX4f3tnq4dWbHgqoMqVhZ32RG8Xnm_JC=QcBHoXWh1g@mail.gmail.com>
References: <1405545610-17285-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1CE47156-DE51-46C6-AE39-C895AF9489EB@net.t-labs.tu-berlin.de>
	<CAA2SeNJRX4f3tnq4dWbHgqoMqVhZ32RG8Xnm_JC=QcBHoXWh1g@mail.gmail.com>
Date: Wed, 16 Jul 2014 16:06:36 -0700
Message-ID: <CAJ-Vmo=eNw9bYdU5yR4tx69kzovgDOzR5e4MPKtmyxe-8qqxUg@mail.gmail.com> (sfid-20140717_010643_035223_3C8A22F4)
Subject: Re: [ath9k-devel] [PATCH] ath9k: set up tx power into the MRR
From: Adrian Chadd <adrian@freebsd.org>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: =?UTF-8?B?VGhvbWFzIEjDvGhu?= <thomas@net.t-labs.tu-berlin.de>,
	John Linville <linville@tuxdriver.com>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys,

Just remember - TPC TX power level 0 is broken on AR5416. ;)

(Check freebsd's ath_hal/ar5416/ar5416_xmit.c code in freebsd-head.)



-a
