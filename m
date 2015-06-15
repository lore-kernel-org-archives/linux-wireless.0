Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45274 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbbFOMgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 08:36:05 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Taehee Yoo <ap420073@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [V2] rtlwifi: rtl8192c: Add init codes for "fw_version" and"fw_subversion".
References: <20150615093851.5F08714086F@smtp.codeaurora.org>
Date: Mon, 15 Jun 2015 15:35:59 +0300
In-Reply-To: <20150615093851.5F08714086F@smtp.codeaurora.org> (Kalle Valo's
	message of "Mon, 15 Jun 2015 09:38:51 +0000 (UTC)")
Message-ID: <87lhfl9mj4.fsf@kamboji.qca.qualcomm.com> (sfid-20150615_143609_228149_69088C84)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

>> The variable "fw_version" is used in the _ResetDigitalProcedure1().
>> but It is not initialized. so I add init codes for "fw_version" and
>> "fw_subversion".
>> 
>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
>
> Thanks, applied to wireless-drivers-next.git.

This patch adds a new sparse warning. Please send a new patch to fix
this.

>> drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c:242:36: sparse: incorrect type in assignment (different base types)
   drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c:242:36:    expected unsigned short [unsigned] [usertype] fw_version
   drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c:242:36:    got restricted __le16 [usertype] version


-- 
Kalle Valo
