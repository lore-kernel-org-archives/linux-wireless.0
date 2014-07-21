Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:36800 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaGUEPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 00:15:34 -0400
Received: by mail-vc0-f176.google.com with SMTP id id10so6503853vcb.7
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 21:15:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1405689992-8538-3-git-send-email-sw@simonwunderlich.de>
References: <1405689992-8538-1-git-send-email-sw@simonwunderlich.de>
	<1405689992-8538-3-git-send-email-sw@simonwunderlich.de>
Date: Mon, 21 Jul 2014 12:15:33 +0800
Message-ID: <CAEFj986Vruig8wCP+RLS_gQf8utAirmTDCKwmMGyfj7B2vH9pw@mail.gmail.com> (sfid-20140721_061537_431983_D459974C)
Subject: Re: [PATCH 2/2] ath10k: add spectral scan feature
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	mathias.kretschmer@fokus.fraunhofer.de, kgiori@qca.qualcomm.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	sven@narfation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 18, 2014 at 9:26 PM, Simon Wunderlich <sw@simonwunderlich.de> wrote:
> Adds the spectral scan feature for ath10k. The spectral scan is triggered by
> configuring a mode through a debugfs control file. Samples can be gathered via
> another relay debugfs file.
>
> Essentially, to try it out:
>
> ip link dev wlan0 set up

It should be "ip link set dev wlan0 up", right?

I have tried to capture the samples on ath10k and open it using fft_eval.

But found the following errors in my samples "invalid bin length 63".

I will send the samples in separate email.

---
Chun-Yeow
