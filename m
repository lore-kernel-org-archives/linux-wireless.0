Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62115 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab3GKJiD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 05:38:03 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH] ath10k: Fix crash when using v1 hardware.
References: <1372804925-1701-1-git-send-email-greearb@candelatech.com>
	<51D35D58.5090507@candelatech.com>
Date: Thu, 11 Jul 2013 12:37:55 +0300
In-Reply-To: <51D35D58.5090507@candelatech.com> (Ben Greear's message of "Tue,
	02 Jul 2013 16:08:08 -0700")
Message-ID: <87txk15te4.fsf@kamboji.qca.qualcomm.com> (sfid-20130711_113806_642638_EFE44867)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> Actually, I have no idea what type of hardware this is.  It was
> suggested earlier to me that this AP had a v1 hardware in it, but
> lspci shows this fairly unpromising thing, and the ath10k driver
> appears to call 003c the V2 hardware....
>
> 05:00.0 Network controller: Atheros Communications Inc. Device 003c (rev ff) (prog-if ff)
> 	!!! Unknown header type 7f
> 	Kernel modules: ath10k_pci

That unknown header type looks scary. I'm starting to suspect even more
that you have a hw problem of some sort.

-- 
Kalle Valo
