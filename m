Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37269 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbbFOSup (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 14:50:45 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Pontus Fuchs <pontusf@broadcom.com>
Subject: Re: [1/7] brcmfmac: Check if firmware supports p2p
References: <20150615101022.23F92140C1F@smtp.codeaurora.org>
	<557F17BF.9060601@broadcom.com>
Date: Mon, 15 Jun 2015 21:50:39 +0300
In-Reply-To: <557F17BF.9060601@broadcom.com> (Arend van Spriel's message of
	"Mon, 15 Jun 2015 20:21:51 +0200")
Message-ID: <874mm8ajr4.fsf@kamboji.qca.qualcomm.com> (sfid-20150615_205049_505627_256C80FE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

>> Thanks, 7 patches applied to wireless-drivers-next.git:
>>
>> 2b560d7148eb brcmfmac: Check if firmware supports p2p
>> 2e5f66fe9593 brcmfmac: Build wiphy mode and interface combinations dynamically
>> 1f0dc59a6de9 brcmfmac: rework .get_station() callback
>> 5768f31e4e75 brcmfmac: have sdio return -EIO when device communication is not possible
>> f37d69a4babc brcmfmac: free ifp for non-netdev interface in p2p module
>> 55479df8840d brcmfmac: move p2p attach/detach functions
>> f7a40873d2fa brcmfmac: assure p2pdev is unregistered upon driver unload
>
> As it turns out two patches in this series introduced a new issue (I
> had one of those days :-( ). I have fixes for them. Should I send them
> now or can it wait until 4.2-rc1 has landed.

Please send them now and I'll try to apply them as soon as possible.

-- 
Kalle Valo
