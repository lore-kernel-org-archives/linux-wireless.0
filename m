Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38645 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2KXNSS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 08:18:18 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so9559901oag.19
        for <linux-wireless@vger.kernel.org>; Sat, 24 Nov 2012 05:18:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87ehjjwiia.fsf@purkki.adurom.net>
References: <1353710779-7142-1-git-send-email-johannes@sipsolutions.net>
	<87ehjjwiia.fsf@purkki.adurom.net>
Date: Sat, 24 Nov 2012 18:48:17 +0530
Message-ID: <CAD2nsn2rqdixfRSyVbxX=+9F7MBbcrdcGy587ansDO==odD+8A@mail.gmail.com> (sfid-20121124_141822_756253_D5C5D186)
Subject: Re: [PATCH] iwlwifi: initialize rx_status
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 24, 2012 at 1:16 PM, Kalle Valo <kvalo@adurom.com> wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>
>> From: Johannes Berg <johannes.berg@intel.com>
>>
>> The vendor radiotap patch added a few fields to
>> struct ieee80211_rx_status that need to be zero,
>> initialize the struct instead of using whatever
>> was left on the stack.
>>
>> Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>
> Just to confirm: latest wireless-testing was crashing for me during
> boot. It was something iwlwifi related, but I didn't manage to see the
> whole stack trace. Applying this patch on top of a1055e1 fixed the issue
> for me.

works for me too, addresses the crash seen for iwlwifi when my machine
boots up with latest wireless-testing.

>
> Tested-by: Kalle Valo <kvalo@adurom.com>
>
> --
> Kalle Valo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
