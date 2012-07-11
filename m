Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36536 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab2GKMtA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 08:49:00 -0400
Message-ID: <4FFD7621.5020207@qca.qualcomm.com> (sfid-20120711_144906_395199_D8D0B9CB)
Date: Wed, 11 Jul 2012 15:48:33 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <drwho@infidigm.net>
CC: Julian Calaby <julian.calaby@gmail.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	<linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: ar6004 / ar9374
References: <43a66e0f20b45e9cc461272e83f2c4e4.squirrel@www.infidigm.net>    <4FFC08C5.2050606@qca.qualcomm.com> <71781241c331fcbb5687068ddc6bbb06.squirrel@www.infidigm.net>
In-Reply-To: <71781241c331fcbb5687068ddc6bbb06.squirrel@www.infidigm.net>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/10/2012 04:42 PM, drwho@infidigm.net wrote:
> We have two units, both come up as 0x31c8088a using your kernel on x86
> Ubuntu or using a recent compat-wireless on our arm platform.  The PN on
> the chip is
> 
> AR9374X-4L3E which is on a usb board
> 
> The bubble wrap has the following....
> UB134-055
> QCABUB134
> HT0430121

Ok, I got more info inside QCA now. 0x31c8088a is a valid hw id for
ar6004/ar9374, it's just that nobody added the support to ath6kl. We are
working on adding it to ath6kl. I cannot give any schedule, but I hope
it happens soon.

Kalle
