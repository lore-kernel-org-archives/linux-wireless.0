Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nsmtp.uni-koblenz.de ([141.26.64.14]:34586 "EHLO
        nsmtp.uni-koblenz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754731AbdIHInv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 04:43:51 -0400
Subject: Re: [PATCH 1/2] wireless: set correct mandatory rate flags
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170907154744.28357-1-rschuetz@uni-koblenz.de>
 <1504853647.6177.8.camel@sipsolutions.net>
From: =?UTF-8?Q?Richard_Sch=c3=bctz?= <rschuetz@uni-koblenz.de>
Message-ID: <85930e91-2c1e-53a6-5b65-d796116295fa@uni-koblenz.de> (sfid-20170908_104355_971137_017FDD72)
Date: Fri, 8 Sep 2017 10:43:44 +0200
MIME-Version: 1.0
In-Reply-To: <1504853647.6177.8.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 08.09.2017 um 08:54 schrieb Johannes Berg:
> On Thu, 2017-09-07 at 17:47 +0200, Richard Schütz wrote:
>> According to IEEE Std 802.11-2016 (16.2.3.4 Long PHY SIGNAL field)
>> all of
>> the following rates are mandatory for a HR/DSSS PHY: 1 Mb/s, 2 Mb/s,
>> 5.5 Mb/s and 11 Mb/s. Set IEEE80211_RATE_MANDATORY_B flag for all of
>> these instead of just 1 Mb/s to correctly reflect this.
> 
> Hmm, I guess technically you're correct, since 11b added what's now
> Clause 16 (was Clause 18 at the time), and that has all of them
> mandatory? But perhaps this was actually intended for Clause 15
> compatibility?

Compatibility in what way?

-- 
Richard
