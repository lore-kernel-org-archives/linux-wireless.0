Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55416 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbcDZJj7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 05:39:59 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
	helmut.schaa@googlemail.com
Subject: Re: [v2] rt2800lib: enable MFP if hw crypt is disabled
References: <20160426093125.0EC23601A1@smtp.codeaurora.org>
Date: Tue, 26 Apr 2016 12:39:55 +0300
In-Reply-To: <20160426093125.0EC23601A1@smtp.codeaurora.org> (Kalle Valo's
	message of "Tue, 26 Apr 2016 09:31:25 +0000 (UTC)")
Message-ID: <87inz4wvx0.fsf@purkki.adurom.net> (sfid-20160426_114004_599718_5CB29107)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

>> If rt2800usb is loaded with nohwcrypt=1, mac80211 takes
>> care of the crypto with software encryption/decryption
>> and thus, MFP can be used.
>> 
>> Tested for secured mesh using ath9k_htc and ath9k.
>> 
>> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
>> 
>> v2: set MFP correctly (Stanislaw Gruszka)
>> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
>
> Thanks, applied to wireless-drivers-next.git.

Afterwards I edited out the change log from the commit log. Add that
after the "---" line so that git won't include it.

-- 
Kalle Valo
