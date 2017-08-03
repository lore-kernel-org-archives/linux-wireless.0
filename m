Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42186 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751933AbdHCKSj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 06:18:39 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Souptick Joarder <jrdr.linux@gmail.com>,
        arend.vanspriel@broadcom.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5] rtlwifi: Replace hardcode value with macro
References: <20170802122915.GA4759@symbol-HP-ZBook-15>
        <4d6b58d1-3e26-e6ea-0c0e-7e2b7aa3b75e@lwfinger.net>
Date: Thu, 03 Aug 2017 13:18:34 +0300
In-Reply-To: <4d6b58d1-3e26-e6ea-0c0e-7e2b7aa3b75e@lwfinger.net> (Larry
        Finger's message of "Wed, 2 Aug 2017 09:35:37 -0500")
Message-ID: <87fud9nedh.fsf@kamboji.qca.qualcomm.com> (sfid-20170803_121847_760788_C01837C7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 08/02/2017 07:29 AM, Souptick Joarder wrote:
>> In _rtl_init_mac80211(), hardcoded value for hw->max_listen_interval
>> and hw->max_rate_tries are replaced by macro and removed the comment.
>>
>> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
>
> Finally!
>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
>
> @Kalle: I'm sure you can work around this, but patchwork shows two
> different "v5" versions and a "v4" entry for this same patch. That may
> be due to no one formally rejecting the patch.

It's because Souptick submitted two v5 patches, but yeah I can that sort
it out.

Souptick, the idea with patch versions is that maintainers and reviewers
can easily find the latest version and drop the rest so ALWAYS increase
the version number. Submitting duplicate version numbers defeats the
purpose and creates extra work for others.

-- 
Kalle Valo
