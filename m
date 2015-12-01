Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:36591 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbbLAIHe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 03:07:34 -0500
Received: by ykdr82 with SMTP id r82so214852737ykd.3
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2015 00:07:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1448889271.3957.2.camel@sipsolutions.net>
References: <1448888094-2707-1-git-send-email-grzegorz.bajorski@tieto.com>
	<1448889271.3957.2.camel@sipsolutions.net>
Date: Tue, 1 Dec 2015 09:07:33 +0100
Message-ID: <CAPGg_YBwPP0n23gJ1o+_jV98MKrCd5MGYShrbyRt0-56Y5Q-8g@mail.gmail.com> (sfid-20151201_090804_528868_2BB53023)
Subject: Re: [PATCH] mac80211: allow drivers to report (non-)monitor frames
From: Grzegorz Bajorski <grzegorz.bajorski@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

already sent in [PATCH] ath10k: deliver mgmt frames from htt to
monitor vifs only.

2015-11-30 14:14 GMT+01:00 Johannes Berg <johannes@sipsolutions.net>:
> On Mon, 2015-11-30 at 13:54 +0100, Grzegorz Bajorski wrote:
>> This allows drivers to tell mac80211 whether given
>> frame is to be processed regularly but skip
>> monitor interface delivery or vice versa.
>>
> Can you give an example, and perhaps a corresponding driver patch?
>
> johannes



-- 
Pozdrawiam / Best Regards
Grzegorz Bajorski
