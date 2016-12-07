Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54078 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752434AbcLGLEe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 06:04:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 07 Dec 2016 16:34:33 +0530
From: Tamizh chelvam <tamizhchelvam@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: c_traja@qti.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH 1/4] cfg80211: Add support to enable or disable btcoex
In-Reply-To: <1480949161.31788.23.camel@sipsolutions.net>
References: <1478610932-21954-1-git-send-email-c_traja@qti.qualcomm.com>
 <1478610932-21954-2-git-send-email-c_traja@qti.qualcomm.com>
 <1480949161.31788.23.camel@sipsolutions.net>
Message-ID: <576b59d939ecd1296b8550de2e63052d@codeaurora.org> (sfid-20161207_120437_989871_BF29515F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Thanks for the comments.

On 2016-12-05 20:16, Johannes Berg wrote:
> On Tue, 2016-11-08 at 18:45 +0530, c_traja@qti.qualcomm.com wrote:
>> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
>> 
>> This patch adds support to enable or disable btcoex by
>> adding NL80211_ATTR_WIPHY_BTCOEX_ENABLE attribute in
>> NL80211_CMD_SET_WIPHY command. By default BTCOEX disabled in driver.
> 
> I think overloading SET_WIPHY even more is a mistake - why not group
> this with the new command you're introducing in the second patch?
> 
Sure.

> Also, can have a flag attribute to enable/disable, or better even
> disable when you're not setting any other parameters.

BTCOEX will be disabled by default. I will use 
NL80211_ATTR_WIPHY_BTCOEX_ENABLE
attribute to enable/disable BTCOEX.
