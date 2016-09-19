Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37320 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932392AbcISSnT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 14:43:19 -0400
Received: by mail-wm0-f49.google.com with SMTP id b130so77974008wmc.0
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2016 11:43:18 -0700 (PDT)
Subject: Re: nl80211 fine timing measurement support
To: Lior David <liord@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>
References: <e7096bbb-ba66-e639-b86e-a483dc198b85@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <45d2980c-aeb4-4faa-e73f-75747124e9eb@broadcom.com> (sfid-20160919_204323_261627_34A6C0AC)
Date: Mon, 19 Sep 2016 20:42:54 +0200
MIME-Version: 1.0
In-Reply-To: <e7096bbb-ba66-e639-b86e-a483dc198b85@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 19-9-2016 19:31, Lior David wrote:
> Hi Johannes,
> 
> We are working on adding indoor location support to the wil6210 11ad driver. This includes fine timing measurement (FTM) as well as something we call angle of arrival (AOA) which measures azimuth and elevation.
> Initially we implemented it internally using vendor commands but we would like to upstream it using standard nl80211 API.
> I noticed a patch you sent some time ago (https://patchwork.kernel.org/patch/7790701/) for adding fine timing measurement support to nl80211, it looks like a good baseline though we do have few issues with it... However I did not see any comments or response on this patch. Can you please update if you plan on eventually submitting this patch?

You can find several FTM related patches in backport-iwlwifi repo on
kernel.org. See link to git log of nl80211.h there [1].

Regards,
Arend

[1]
https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/backport-iwlwifi.git/log/include/uapi/linux/nl80211.h
