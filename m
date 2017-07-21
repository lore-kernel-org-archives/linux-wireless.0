Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54048 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754794AbdGUQ5e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 12:57:34 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ningyuan Wang <nywang@google.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Print NL80211_BSS_LAST_SEEN_BOOTTIME on scan results
References: <20170711004746.142837-1-nywang@google.com>
        <87o9sd24yl.fsf@purkki.adurom.net>
        <CACS3zKWXPYK98kuBBXnwXa84H5DrB8Mv4UbF7NdM3DFJ9G3PdQ@mail.gmail.com>
Date: Fri, 21 Jul 2017 19:57:29 +0300
In-Reply-To: <CACS3zKWXPYK98kuBBXnwXa84H5DrB8Mv4UbF7NdM3DFJ9G3PdQ@mail.gmail.com>
        (Ningyuan Wang's message of "Fri, 21 Jul 2017 09:33:40 -0700")
Message-ID: <8760el3eyu.fsf@kamboji.qca.qualcomm.com> (sfid-20170721_185751_239506_3C2998AA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ningyuan Wang <nywang@google.com> writes:

> Signed-off-by: Ningyuan Wang <nywang@google.com>
> ---
> nl80211.h | 4 ++++
> scan.c | 11 +++++++++++
> 2 files changed, 15 insertions(+)
>
> diff --git a/nl80211.h b/nl80211.h
> index 241220c..5ea103c 100644
> --- a/nl80211.h
> +++ b/nl80211.h
> @@ -3360,6 +3360,9 @@ enum nl80211_bss_scan_width {
> * (not present if no beacon frame has been received yet)
> * @NL80211_BSS_PRESP_DATA: the data in
> @NL80211_BSS_INFORMATION_ELEMENTS and

The patch looks to be corrupted, patchwork won't see it either:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#format_issues

-- 
Kalle Valo
