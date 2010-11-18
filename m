Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60424 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab0KRS4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 13:56:04 -0500
Received: by yxf34 with SMTP id 34so2077847yxf.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 10:56:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikb0-VUh5LfHC9T47c=shNSdtF40ZZzYN3KkAYN@mail.gmail.com>
References: <1290059169-2468-1-git-send-email-lrodriguez@atheros.com>
 <AANLkTikACJ35YFDCS5NucXjhNDFyT7VU9FeYUGY9hMmo@mail.gmail.com>
 <AANLkTim28M7aRPSS1W71dEQ0a7PxS8QxKHAZ8jhx7C+2@mail.gmail.com> <AANLkTikb0-VUh5LfHC9T47c=shNSdtF40ZZzYN3KkAYN@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 18 Nov 2010 10:55:41 -0800
Message-ID: <AANLkTins+HeRPAcXWNLGw_4asTGor_LeTfcrpVjUpqCg@mail.gmail.com>
Subject: Re: [PATCH 0/4] cfg80211: fix bug with multiple cards and a CRDA delay
To: Mark Mentovai <mark@moxienet.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 18, 2010 at 10:52 AM, Mark Mentovai <mark@moxienet.com> wrote:
> Luis R. Rodriguez wrote:
>> I did but did not see any difference in your comments.
>
> “whether or not this requests has already” — request, not requests.
> “currently regulatory domain set” — should be “currently set regulatory domain”.
> “When a the last request” — no a, just the.

Don't get it, please send a patch on top of this :)

>> Tesed-by: foo would be good.
>
> Sure!
>
> Tested-by: Mark Mentovai <mark@moxienet.com>

Thanks,

  Luis
