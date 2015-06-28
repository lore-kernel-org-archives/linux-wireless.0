Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37394 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbbF1Reb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Jun 2015 13:34:31 -0400
Received: by wicgi11 with SMTP id gi11so54023494wic.0
        for <linux-wireless@vger.kernel.org>; Sun, 28 Jun 2015 10:34:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <fff70f4adca53a929cda056a21f4d3ad@mail.gmail.com>
References: <CAEFj986a0b9r4qia-CFXsm_aiD8P5gLeJJqxS2NYcSjKcspLNw@mail.gmail.com>
	<4bd697c41f2bb66593c849246bde7b00@mail.gmail.com>
	<CAEFj9878gNnDViLYh+TW6GPUvJBbSn4Y=tDBmdp3NwBHymqxRg@mail.gmail.com>
	<b193de6c0b11af0193414a217f0ea56b@mail.gmail.com>
	<CAEFj986Jt-1rymgARCvDe+2Tb1R0PqsDfSELC7WbAXfkC+9xPw@mail.gmail.com>
	<fff70f4adca53a929cda056a21f4d3ad@mail.gmail.com>
Date: Mon, 29 Jun 2015 01:34:30 +0800
Message-ID: <CAEFj987riY6NKta+aYuN3bV9R9yQ3FdLLJGcdry98t++E2ZHvQ@mail.gmail.com> (sfid-20150628_193441_623539_135ABFF3)
Subject: Re: [PATCH] mac80211: mesh - always do every discovery retry
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Jesse Jones <jjones@cococorp.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> I'm not keen on the idea. I still think it's the right thing to do and I
> don't much like the idea of having to turn it on. And it will become an even
> better idea if we don't refresh as often (eventually I'll send a patch for
> that though I think I may have to massage what we're using now).
>

Since you have make up your mind, I have no further comment on this.

But I would suggest you to fix the MESH_MAX_PREQ_RETRIES to default 1.

---
Chun-Yeow
