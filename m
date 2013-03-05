Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35213 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab3CETng (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 14:43:36 -0500
Received: by mail-oa0-f46.google.com with SMTP id k1so11431740oag.5
        for <linux-wireless@vger.kernel.org>; Tue, 05 Mar 2013 11:43:35 -0800 (PST)
Message-ID: <51364AE5.70908@lwfinger.net> (sfid-20130305_204340_499389_110C4178)
Date: Tue, 05 Mar 2013 13:43:33 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
Subject: Re: WARNING from net/wireless/mlme.c
References: <513570D0.4070302@lwfinger.net>  (sfid-20130305_051310_497727_E0519ADC) <1362511955.638.3.camel@jlt4.sipsolutions.net>
In-Reply-To: <1362511955.638.3.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/2013 01:32 PM, Johannes Berg wrote:
> Hi Larry,
>
>> With 3.9-rc1 from wireless-testing, I get a warning from the line
>>           if (WARN(!wdev->current_bss, "sme_state=%d\n", wdev->sme_state))
>>
>> [ 4250.226882] ------------[ cut here ]------------
>> [ 4250.226929] WARNING: at net/wireless/mlme.c:517
>> cfg80211_mlme_disassoc+0x192/0x3a0 [cfg80211]()
>> [ 4250.226933] Hardware name: HP Pavilion dv2700 Notebook PC
>> [ 4250.226936] sme_state=2
>
> Heh, adding the sme_state=2 there was stupid of me ... there's an if
> right in front. Oh well.
>
> Anyway, can you reproduce this? I looked at the code for the umpteenth
> time and can't really find it. Capturing cfg80211 tracing might be
> helpful.

I'll turn on cfg80211 debugging and let you know when it happens again.

Larry


