Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45496 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388161AbeGWQ3k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 12:29:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 23 Jul 2018 18:27:55 +0300
From: merez@codeaurora.org
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH 11/20] wil6210: send L2UF on behalf of newly associated
 station
In-Reply-To: <1532289708.3680.3.camel@sipsolutions.net>
References: <1532245665-15249-1-git-send-email-merez@codeaurora.org>
 <1532245665-15249-12-git-send-email-merez@codeaurora.org>
 (sfid-20180722_095029_900823_BD03869E)
 <1532289708.3680.3.camel@sipsolutions.net>
Message-ID: <57ae228b9472a4026bc12f45c0ba06f5@codeaurora.org> (sfid-20180723_172759_454150_E6E12DE6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-07-22 23:01, Johannes Berg wrote:
> On Sun, 2018-07-22 at 10:47 +0300, Maya Erez wrote:
>> From: Ahmad Masri <amasri@codeaurora.org>
>> 
>> Send L2UF (Level 2 Update Frame) to update forwarding tables in layer 
>> 2
>> in AP mode. Wil6210 driver creates and sends this frame once a new
>> station connects to the AP.
> 
> Might be worth unifying with ieee80211_send_layer2_update() into a new
> cfg80211 function?
> 
> johannes
We will do that. I'll revert this patch.
-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
