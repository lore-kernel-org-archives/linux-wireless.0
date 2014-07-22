Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:39851 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaGVE7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 00:59:21 -0400
Received: by mail-vc0-f171.google.com with SMTP id hq11so12462074vcb.30
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2014 21:59:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201407211143.04868.sw@simonwunderlich.de>
References: <1405689992-8538-1-git-send-email-sw@simonwunderlich.de>
	<1405689992-8538-3-git-send-email-sw@simonwunderlich.de>
	<CAEFj986Vruig8wCP+RLS_gQf8utAirmTDCKwmMGyfj7B2vH9pw@mail.gmail.com>
	<201407211143.04868.sw@simonwunderlich.de>
Date: Tue, 22 Jul 2014 12:59:20 +0800
Message-ID: <CAEFj9878tYieueZn4fn4EZSgPSTTnoTj4Xb8wu_Es1gHy0KEqQ@mail.gmail.com> (sfid-20140722_065928_126793_EFF94A7A)
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

Hi, Simon

>
> Thanks for the output! Could it be that you are using the old RFC patch with
> the new fft-eval? I've added another byte (max_exp), so the header became
> longer. Please try again with the latest patch (from this thread), if that is
> the case. Otherwise we have to find out whats wrong ... The sample_len as used
> in fft_eval (tlv-header + data) should be 93 with that version.

Yes, you are right. I am picking out the ath-next-test branch which is
using the RFC old patch before that.

By the way, the new submitted patch v2 [1] has taken out the following:

if (mode == SPECTRAL_BACKGROUND)ath10k_spectral_scan_trigger(ar);


-----
Chun-Yeow

[1] http://lists.infradead.org/pipermail/ath10k/2014-July/002711.html
