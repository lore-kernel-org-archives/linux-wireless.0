Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40714 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab0KRSwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 13:52:40 -0500
Received: by qwd7 with SMTP id 7so417229qwd.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 10:52:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTim28M7aRPSS1W71dEQ0a7PxS8QxKHAZ8jhx7C+2@mail.gmail.com>
References: <1290059169-2468-1-git-send-email-lrodriguez@atheros.com>
	<AANLkTikACJ35YFDCS5NucXjhNDFyT7VU9FeYUGY9hMmo@mail.gmail.com>
	<AANLkTim28M7aRPSS1W71dEQ0a7PxS8QxKHAZ8jhx7C+2@mail.gmail.com>
Date: Thu, 18 Nov 2010 13:52:39 -0500
Message-ID: <AANLkTikb0-VUh5LfHC9T47c=shNSdtF40ZZzYN3KkAYN@mail.gmail.com>
Subject: Re: [PATCH 0/4] cfg80211: fix bug with multiple cards and a CRDA delay
From: Mark Mentovai <mark@moxienet.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> I did but did not see any difference in your comments.

“whether or not this requests has already” — request, not requests.
“currently regulatory domain set” — should be “currently set regulatory domain”.
“When a the last request” — no a, just the.

> Tesed-by: foo would be good.

Sure!

Tested-by: Mark Mentovai <mark@moxienet.com>
