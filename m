Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:36755 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbZGaSjc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 14:39:32 -0400
Received: by ewy10 with SMTP id 10so1718903ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 11:39:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890907311114k5a049c08jfa40a3ed45e9afed@mail.gmail.com>
References: <20090731180805.GD7963@makis>
	 <43e72e890907311114k5a049c08jfa40a3ed45e9afed@mail.gmail.com>
Date: Fri, 31 Jul 2009 21:39:31 +0300
Message-ID: <40f31dec0907311139le0f279bl54bc897d1c716582@mail.gmail.com>
Subject: Re: [PATCH 3/4] ath5k: Wakeup fixes
From: Nick Kossifidis <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/7/31 Luis R. Rodriguez <mcgrof@gmail.com>:
> On Fri, Jul 31, 2009 at 11:08 AM, Nick
> Kossifidis<mick@madwifi-project.org> wrote:
>>  * Don't put chip to full sleep because there are problems during
>>   wakeup. Instead hold MAC/Baseband on warm reset state via a new
>>   function ath5k_hw_on_hold.
>>
>>  * Durring attach preserve pcicfg bits when enabling pci core
>>   sw retry fix.
>>
>>  * Minor cleanups
>
> Can you address these changes separately? I see you tend to itemize
> the things you change, even when you just make one change. Please
> consider addressing one change per commit and just ensure the why is
> crystal clear.
>
>  Luis
>

Cleanup doesn't count as a change, the only real change is the first one.
I 'm trying not to pollute the logs. This patch fixes an issue reported when
card doesn't wake up.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
