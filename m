Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58558 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbbARXdr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2015 18:33:47 -0500
Received: by mail-ob0-f174.google.com with SMTP id wo20so16520934obc.5
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2015 15:33:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150116125957.GA10300@localhost>
References: <1421202189-4020-1-git-send-email-masashi.honma@gmail.com>
	<CAEKwDSDPTiZH1NO8Hi-bdPp=25yARr1iUFK7ntnnS6Ae05ULaA@mail.gmail.com>
	<CAFk-A4ko5S_+SFNk8RWvrWJ9k-kEQnqKCEKrTZs0GrZ9QScMJA@mail.gmail.com>
	<20150116125957.GA10300@localhost>
Date: Mon, 19 Jan 2015 08:33:47 +0900
Message-ID: <CAFk-A4=gLKTcDJ1kD+E3T2c+fJGPQxdmsh+ViBfuvCghJ-G5kA@mail.gmail.com> (sfid-20150119_003445_671678_2719A958)
Subject: Re: [PATCH] mesh: Skip STA expiration on user_mpm mode
From: Masashi Honma <masashi.honma@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-01-16 21:59 GMT+09:00 Bob Copeland <me@bobcopeland.com>:
> No, it relies on mac80211's inactivity timer.  So, yeah, I think this
> patch would break authsae, in the sense that stations would never
> get removed.

I see. I will drop this patch.
