Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:46132 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbaF3JqF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 05:46:05 -0400
Received: by mail-we0-f174.google.com with SMTP id u57so8012571wes.33
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2014 02:46:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1403722063.4140.19.camel@jlt4.sipsolutions.net>
References: <1403692510-27873-1-git-send-email-michal.kazior@tieto.com>
	<1403722063.4140.19.camel@jlt4.sipsolutions.net>
Date: Mon, 30 Jun 2014 11:46:03 +0200
Message-ID: <CA+BoTQmizEd3joLf6XDuUrq1Ton_XWcTwKCzWHJcD=gbzVGoMg@mail.gmail.com> (sfid-20140630_114610_453010_066E5130)
Subject: Re: [PATCH v11 0/5] cfg/mac80211: implement multi-vif csa
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 June 2014 20:47, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-06-25 at 12:35 +0200, Michal Kazior wrote:
>> Hi,
>>
>> The patchset implements multi-interface
>> reservations and multi-interface channel
>> switching.
>>
>> There are still some cases that aren't handled
>> well (at least degradation of number of channels
>> due to interface combinations that I'm aware of).
>>
>>
>> v11:
>>  * rebase to latest mac80211-next/master
>>    (eb6a61549f530f1cc435512df3799f656094ba83)
>>  * lots of fixes (see notes in [1/5])
>
> Applied all.

Thanks!

Btw. What is the plan regarding re-enabling CSA itself?


Michał
