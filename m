Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55327 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbcDZJjH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 05:39:07 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?David_M=C3=BCller_=28ELSOFT_AG=29?= <d.mueller@elsoft.ch>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [v2] rtlwifi: rtl8821ae: Make sure loop counter is signed on allarchitectures
References: <20160426091116.17FCA6120F@smtp.codeaurora.org>
Date: Tue, 26 Apr 2016 12:39:03 +0300
In-Reply-To: <20160426091116.17FCA6120F@smtp.codeaurora.org> (Kalle Valo's
	message of "Tue, 26 Apr 2016 09:11:16 +0000 (UTC)")
Message-ID: <87mvogwvyg.fsf@purkki.adurom.net> (sfid-20160426_113912_542084_9634B4F5)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

>> The for-loop condition does not work correctly on architectures where
>> "char" is unsigned. Fix it by using an "int", which may also result in
>> more efficient code.
>> 
>> v2: Remove unneeded initialization.
>> 
>> Signed-off-by: David Müller <d.mueller@elsoft.ch>
>> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
>
> Thanks, applied to wireless-drivers-next.git.

But afterwards I removed the change log. That doesn't belong to the
commit log, please add that after "---" line separator.

Also in patchwork your name has (ELSOFT AG), I edited that out.

-- 
Kalle Valo
