Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:52019 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510Ab0INVsi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 17:48:38 -0400
To: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>
Cc: "linville\@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k_htc: Enable fastcc for HTC devices.
References: <1283497888-8294-1-git-send-email-rmanoharan@atheros.com>
	<87zkvk5tyx.fsf@purkki.adurom.net>
	<44EE5C37ADC36343B0625A05DD408C4850DAB4D6C2@CHEXMB-01.global.atheros.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 15 Sep 2010 00:48:35 +0300
In-Reply-To: <44EE5C37ADC36343B0625A05DD408C4850DAB4D6C2@CHEXMB-01.global.atheros.com> (Rajkumar Manoharan's message of "Tue\, 14 Sep 2010 23\:14\:17 +0530")
Message-ID: <87r5gw574c.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com> writes:

>>For example, I have no idea what fastcc means. Fast C Compiler? ;)
>
> On every channel set, the full hw reset happens which issue mutiple
> register writes. For HTC devices, the host issue wmi commands. These
> register ops are time consumable one. Instead of full hw reset,
> ath9k is doing partial reset which is fast channel change (fastcc).
> By doing fast channel change, the scan period is considerably
> reduced.

Now this is a good commit message. I can understand what the change is
actually about without browsing through ath9k source. Of course it
takes few minutes to write this but on the other hand you save a lot
of time from others. And possibly avoid answering to stupid questions
like the one I had :)

Thanks.

-- 
Kalle Valo
