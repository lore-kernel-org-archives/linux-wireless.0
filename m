Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59640 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbcFPPkC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 11:40:02 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: John S Gruber <johnsgruber@gmail.com>
CC: Miaoqing Pan <miaoqing@codeaurora.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ATH9K warnings from commit b2d70d494
Date: Thu, 16 Jun 2016 15:39:43 +0000
Message-ID: <8737odw3b5.fsf@kamboji.qca.qualcomm.com> (sfid-20160616_174007_645410_C0CB34D1)
References: <CAPotdmQA6qwbUD9g7BLc_ad3VZ57y4FX_6UJ3ibMovC7Kaa4TA@mail.gmail.com>
	<87ziqlpeue.fsf@qca.qualcomm.com>
	<CAPotdmTXsNC0AeqqKEa0_WQUA-4tuS8sMJtU5VRxZcWSM4iVgQ@mail.gmail.com>
In-Reply-To: <CAPotdmTXsNC0AeqqKEa0_WQUA-4tuS8sMJtU5VRxZcWSM4iVgQ@mail.gmail.com>	(John S.
 Gruber's message of "Thu, 16 Jun 2016 15:11:10 +0000")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John S Gruber <johnsgruber@gmail.com> writes:

> It's an AR9462
>
> Here's the wifi adapter:
>
> 03:00.0 Network controller: Qualcomm Atheros AR9462 Wireless Network Adapter
> (rev 01)
> Subsystem: Lite-On Communications Inc Device 6621
> Flags: bus master, fast devsel, latency 0, IRQ 19
> Memory at f7c00000 (64-bit, non-prefetchable) [size=512K]
> Expansion ROM at f7c80000 [disabled] [size=64K]
> Capabilities: [40] Power Management version 2
> Capabilities: [50] MSI: Enable- Count=1/4 Maskable+ 64bit+
> Capabilities: [70] Express Endpoint, MSI 00
> Capabilities: [100] Advanced Error Reporting
> Capabilities: [140] Virtual Channel
> Capabilities: [160] Device Serial Number 00-00-00-00-00-00-00-00
> Kernel driver in use: ath9k
>
> The warnings go away with the patch you identified and wifi and bluetooth are
> working.

Great, thanks for testing. The patch will go to 4.7-rc release in a week
or two.

-- 
Kalle Valo