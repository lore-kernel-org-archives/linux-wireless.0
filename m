Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39600 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab2E0CK2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 22:10:28 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20417.36056.95300.690329@gargle.gargle.HOWL> (sfid-20120527_041032_687110_3640C5CF)
Date: Sun, 27 May 2012 07:39:28 +0530
To: Adrian Chadd <adrian@freebsd.org>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Anyone doing WiFi throughput tests?
In-Reply-To: <20417.35821.91808.2702@gargle.gargle.HOWL>
References: <4FC04B5A.1070900@candelatech.com>
	<CAJ-VmomRv-GdRooL=1G5avxAqJ4h3eoAfNkzYit3ok-fXmd25A@mail.gmail.com>
	<20417.35821.91808.2702@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> Odd. I get low numbers with a DB120 running OpenWRT (git HEAD).
> 
> TCP TX - ~260 Mbps.
> TCP RX - ~160 Mbps.
> 
> UDP RX - ~240 Mbps.
> UDP TX - iperf borks and doesn't display anything.
> 
> The load seems to be a bit high (average: 1.92, 1.06, 0.61 ) and the
> console becomes laggy.
> 
> Maybe 

Huh.

Now that I have added "(setq vm-confirm-mail-send t)" to my .emacs, I'll
finish the email. :)

Maybe support for DB120 is not complete yet - but am not sure.

Sujith
