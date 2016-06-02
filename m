Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52996 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932753AbcFBOfu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 10:35:50 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	Franky Lin <franky.lin@broadcom.com>
Subject: Re: [PATCH for-4.7] brcmfmac: add eth_type_trans back for PCIe full dongle
References: <1464815616-21551-1-git-send-email-arend@broadcom.com>
	<87mvn4lyle.fsf@purkki.adurom.net> <87a8j4lyc2.fsf@purkki.adurom.net>
	<5750426E.6000800@broadcom.com>
Date: Thu, 02 Jun 2016 17:35:44 +0300
In-Reply-To: <5750426E.6000800@broadcom.com> (Arend van Spriel's message of
	"Thu, 2 Jun 2016 16:27:58 +0200")
Message-ID: <87wpm7y7y7.fsf@kamboji.qca.qualcomm.com> (sfid-20160602_163604_459476_75B9101D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

>>>> Reported-by: Grey Christoforo <grey@christoforo.net>
>>>
>>> I'll add a fixes line before I commit:
>>>
>>> Fixes: 9c349892ccc9 ("brcmfmac: revise handling events in receive path")
>
> I realized it was missing. Not yet used to that tag. So I already sent a
> V2 patch.

Yeah, saw that and dropped this one. Thanks.

-- 
Kalle Valo
