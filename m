Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:53292 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3LEJnX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 04:43:23 -0500
Received: by mail-pd0-f171.google.com with SMTP id z10so24307036pdj.30
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 01:43:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386080727.4393.30.camel@jlt4.sipsolutions.net>
References: <1385883096-7143-1-git-send-email-royujjal@gmail.com>
	<1385890375.4171.0.camel@jlt4.sipsolutions.net>
	<CAE2MWkkA+5ki90wJ+vkSdeBiXygVv9vXhpGp0h+84+fbgbga0g@mail.gmail.com>
	<1386080727.4393.30.camel@jlt4.sipsolutions.net>
Date: Thu, 5 Dec 2013 15:13:22 +0530
Message-ID: <CAE2MWknzO8gBx7FmBiVsOHXP2MYo-L7mV2FYDG7hj6=tHAV=zw@mail.gmail.com> (sfid-20131205_104328_926320_A29358C7)
Subject: Re: [PATCH] cfg80211: fix WARN_ON for re-association to the expired BSS
From: Ujjal Roy <royujjal@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Kernel <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Why would you ever reassoc to the exact same BSS? But anyway ... I'll
> take a closer look at your patch/the code.
>
> johannes
>

cfg80211 allows to do that. So, its the responsibility of cfg80211
not to have any issues if anyone uses this type of reassoc.

-- 
Thanks,
UjjaL Roy
