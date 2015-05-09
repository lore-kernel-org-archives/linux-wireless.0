Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53299 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbbEIOCQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2015 10:02:16 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Rafa? Mi?ecki <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: brcmfmac: check result of USB firmware request
References: <20150509135932.7CA5F1402BC@smtp.codeaurora.org>
Date: Sat, 09 May 2015 17:02:09 +0300
In-Reply-To: <20150509135932.7CA5F1402BC@smtp.codeaurora.org> (Kalle Valo's
	message of "Sat, 9 May 2015 13:59:32 +0000 (UTC)")
Message-ID: <873835n926.fsf@kamboji.qca.qualcomm.com> (sfid-20150509_160219_961375_144B3208)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

>> This prevents silence failures with driver waiting (infinitely) for a
>> callback.
>> 
>> Signed-off-by: Rafa? Mi?ecki <zajec5@gmail.com>
>> Acked-by: Arend van Spriel <arend@broadcom.com>
>
> Thanks, applied to wireless-drivers-next.git.

But before I pushed I manually fixed the UTF-8 problem caused by the
patchwork bug.

-- 
Kalle Valo
