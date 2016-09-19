Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38458 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750867AbcISRbH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 13:31:07 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Maya Erez <merez@codeaurora.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org
From: Lior David <liord@codeaurora.org>
Subject: nl80211 fine timing measurement support
Message-ID: <e7096bbb-ba66-e639-b86e-a483dc198b85@codeaurora.org> (sfid-20160919_193111_167047_65AEBFA7)
Date: Mon, 19 Sep 2016 20:31:01 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

We are working on adding indoor location support to the wil6210 11ad driver. This includes fine timing measurement (FTM) as well as something we call angle of arrival (AOA) which measures azimuth and elevation.
Initially we implemented it internally using vendor commands but we would like to upstream it using standard nl80211 API.
I noticed a patch you sent some time ago (https://patchwork.kernel.org/patch/7790701/) for adding fine timing measurement support to nl80211, it looks like a good baseline though we do have few issues with it... However I did not see any comments or response on this patch. Can you please update if you plan on eventually submitting this patch?

Thanks,
Lior
