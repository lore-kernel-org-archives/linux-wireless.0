Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59437 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269AbbBZNUL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 08:20:11 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org,
	wlanfae@realtek.com
Subject: Re: [PATCH 1/1] rtlwifi: Clear ACM_CTRL AC3_VO bit correctly
References: <1423261472-4607-1-git-send-email-Jes.Sorensen@redhat.com>
	<1423261472-4607-2-git-send-email-Jes.Sorensen@redhat.com>
	<54D9799D.5090909@lwfinger.net>
Date: Thu, 26 Feb 2015 15:20:07 +0200
In-Reply-To: <54D9799D.5090909@lwfinger.net> (Larry Finger's message of "Mon,
	09 Feb 2015 21:23:09 -0600")
Message-ID: <87r3tcdd2w.fsf@kamboji.qca.qualcomm.com> (sfid-20150226_142042_504719_7B47F771)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 02/06/2015 04:24 PM, Jes.Sorensen@redhat.com wrote:
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> All hw driver components in the rtlwifi driver, except for the
>> rtl8192de component has this bug. They would clear BE bit in the
>> ACM_CTRL register instead of the VO bit when processing the VO queue.
>>
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> Jes,
>
> Good catch. Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

BTW, if you want patchwork to use that Acked-by line add it to a line of
it's own. Otherwise it will ignore it.

-- 
Kalle Valo
