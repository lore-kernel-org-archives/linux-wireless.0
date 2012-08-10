Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:65118 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab2HJLms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 07:42:48 -0400
Received: by ggdk6 with SMTP id k6so1460185ggd.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2012 04:42:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50240673.7070404@hauke-m.de>
References: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
	<1344535292-4451-7-git-send-email-ozancag@gmail.com>
	<50240673.7070404@hauke-m.de>
Date: Fri, 10 Aug 2012 14:42:47 +0300
Message-ID: <CAFub=KT6gDw7eDG1B9Svqv+Fyv4EJzHmG7zM5_cQ=+-wxjwo2Q@mail.gmail.com> (sfid-20120810_134251_320629_8A6DA966)
Subject: Re: [PATCH 06/13] compat-wireless: Conditionally build network drivers
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Why are you adding the subsystems "wlan, bluetooth, ethernet" in a
> previous patch and now remove them? If you reverted your original plan
> to add these three subsystems and now came to the conclusion it would
> need some more work, this is no problem, but you should modify your
> first patch and add only that one network subsystem in the first patch
> and just add drm in this one.

Yep you're right. I was actually going to ask about it and then I
decided to send these patches mainly for getting comments so I didn't
take my time to merge the incremental changes.

Thanks.
