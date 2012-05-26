Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61669 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab2EZL3h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 07:29:37 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20416.48743.815578.238107@gargle.gargle.HOWL> (sfid-20120526_133015_202714_1AAAE8FF)
Date: Sat, 26 May 2012 16:58:39 +0530
To: Josef Semler <josef.semler@gmail.com>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	Ben Greear <greearb@candelatech.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Anyone doing WiFi throughput tests?
In-Reply-To: <CAPsaeQPxh0Yd+GT3HbReAAtoPhKF2c3kOzgOPL6xK7NC=8J4qA@mail.gmail.com>
References: <4FC04B5A.1070900@candelatech.com>
	<20416.19680.571601.549629@gargle.gargle.HOWL>
	<7759D07D-C2C8-48D8-8F44-687C7E85D188@gmail.com>
	<20416.35246.76971.129331@gargle.gargle.HOWL>
	<CAPsaeQPxh0Yd+GT3HbReAAtoPhKF2c3kOzgOPL6xK7NC=8J4qA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Josef Semler wrote:
> OK, tnx Sujith, but that brings me to my next question acc. 2x2 or 3x3 on
> OpenWRT-based devices like NanoStation M or AirBridge M.  Up to now only 1x2
> or 1x3 was possible on this devices. Do we have changings there too?

Hm, am not sure about these devices. But, the number of streams is determined
based on the chip, and there is nothing that can be done to increase it. If
you have access, load the driver with the parameter 'debug=0x200' and check
dmesg - this should show the number of TX/RX streams.

Sujith
