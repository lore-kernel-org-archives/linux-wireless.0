Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:45271 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbZGKP0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jul 2009 11:26:16 -0400
Received: by ewy26 with SMTP id 26so1719532ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 11 Jul 2009 08:26:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090709211221.GA4854@steven676.net>
References: <20090709211221.GA4854@steven676.net>
Date: Sat, 11 Jul 2009 18:26:14 +0300
Message-ID: <40f31dec0907110826o75f73dbfw2aed84304feff264@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Fix enabling OFDM weak signal detection
From: Nick Kossifidis <mickflemm@gmail.com>
To: Steven Luo <steven@steven676.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/7/10 Steven Luo <steven@steven676.net>:
> From: Steven Luo <steven@steven676.net>
>
> It seems that OFDM weak signal detection should be enabled after an ANI
> state reset, as indicated by the initial setting of ofdmWeakSigDetectOff
> and what the open Atheros HAL does.  Unfortunately, the reversed sense
> of ofdmWeakSigDetectOff (true if weak signal detection is NOT enabled)
> seems to have resulted in a mixup here, causing weak signal detection to
> be disabled.
>
> This patch significantly improves reception and throughput from distant
> stations for my AR5416-based AP running compat-wireless 2009-06-25.
>

(sorry, bad reply to all)

Does your AP operate on 2.4GHz band or 5GHz ?

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
