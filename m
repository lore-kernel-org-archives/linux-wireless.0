Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.188]:36053 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbZAMXAc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 18:00:32 -0500
Received: by rn-out-0910.google.com with SMTP id k40so242431rnd.17
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 15:00:30 -0800 (PST)
Message-ID: <43e72e890901131500j32357b92kf57c0b12d38c9ad5@mail.gmail.com> (sfid-20090114_000036_486650_B9DC89F8)
Date: Tue, 13 Jan 2009 15:00:30 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 12/12] cfg80211: Remove CONFIG_WIRELESS_OLD_REGULATORY
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1231887058.3728.6.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-6-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-7-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-8-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-9-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-10-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-11-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-12-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-13-git-send-email-lrodriguez@atheros.com>
	 <1231887058.3728.6.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 13, 2009 at 2:50 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2009-01-13 at 11:57 -0800, Luis R. Rodriguez wrote:
>> This removal was scheduled for 2.6.29 but we decided to
>> keep it around a bit longer. Now that we are on road to
>> 2.6.30 lets remove it.
>
> Don't like this much, it's not really biting us (yet) to have this code
> around still.

It means double testing, I was going to test all the work in this
series with this option but I figured it'd be better to move on.

  Luis
