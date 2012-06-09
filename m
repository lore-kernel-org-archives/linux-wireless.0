Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38645 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab2FIQLz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 12:11:55 -0400
Received: by yenm10 with SMTP id m10so1863851yen.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Jun 2012 09:11:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339231619.4539.32.camel@jlt3.sipsolutions.net>
References: <1339043963-2043-1-git-send-email-yeohchunyeow@gmail.com>
	<1339043963-2043-5-git-send-email-yeohchunyeow@gmail.com>
	<1339231619.4539.32.camel@jlt3.sipsolutions.net>
Date: Sun, 10 Jun 2012 00:11:54 +0800
Message-ID: <CAEFj987SuLhiMcdhu6rRUn-UTfpgJ2Oe1wVhQyq41QZTOrwZhw@mail.gmail.com> (sfid-20120609_181158_895521_5859A725)
Subject: Re: [PATCH v2 4/4] mac80211: invoke the timer only with correct
 dot11MeshHWMPRootMode value
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> so, humm, there's still the same constant here.
>
> and here.
>

Possible to stick to the number, because in the standard it define
(0) no root
(2) proactive PREQ no PREP
(3) proactive RPEQ with PREP
(4) RANN

Not so sure what's the proper naming for this constant.

Chun-Yeow
