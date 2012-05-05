Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61523 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab2EEPjZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 May 2012 11:39:25 -0400
Received: by yenm10 with SMTP id m10so3005754yen.19
        for <linux-wireless@vger.kernel.org>; Sat, 05 May 2012 08:39:24 -0700 (PDT)
Message-ID: <4FA549A9.9010302@lwfinger.net> (sfid-20120505_173928_577502_4D3E0EC1)
Date: Sat, 05 May 2012 10:39:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix 'suspicious RCU usage' warning
References: <4fa3dcf0.+lkNsTVufgE2rrvO%Larry.Finger@lwfinger.net> <1336231147.3716.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1336231147.3716.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/05/2012 10:19 AM, Johannes Berg wrote:
> On Fri, 2012-05-04 at 08:43 -0500, Larry Finger wrote:
>> From: Johannes Berg<johannes@sipsolutions.net>
>>
>> When running kernel 3.4-rc2 from wireless testing, the following is logged:
>
>> Reported-and-tested-by:: Larry Finger<Larry.Finger@lwfinger.net>
>> Signed-off-by: Johannes Berg<johannes@sipsolutions.net>
>
> Wait wait, I never signed this off yet. You really can't pretend I did.

Sorry. I thought you did.

Larry

