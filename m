Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:36297 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbbFNN5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jun 2015 09:57:24 -0400
Received: by oial131 with SMTP id l131so11350503oia.3
        for <linux-wireless@vger.kernel.org>; Sun, 14 Jun 2015 06:57:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <557BF43F.3050402@rempel-privat.de>
References: <1433836789-5505-1-git-send-email-yeohchunyeow@gmail.com>
	<557BF43F.3050402@rempel-privat.de>
Date: Sun, 14 Jun 2015 21:57:23 +0800
Message-ID: <CAEFj987UVBTNqU2puWW_PWkrjqAw6zEJSo+z2CTugOrdVye3tg@mail.gmail.com> (sfid-20150614_155728_156398_F89F5EC0)
Subject: Re: [PATCH] ath9k_htc: add support of channel switch
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: kvalo@codeaurora.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jun 13, 2015 5:13 PM, "Oleksij Rempel" <linux@rempel-privat.de> wrote:
>
> Hi,
>
> Thank you for your work.
> How can i test this patch?

I have brought up two mesh nodes operating at channel 11 HT20. After
that, triggering the mesh channel switching using iw command "iw meshX
mesh chswitch 6 10 HT20" to switch to channel 6 after 10 TBTT.

iw command:
https://github.com/cozybit/iw/commit/d64a0ae1039e386304a5125614ac5f1001e977f8

You can give it a try. Thanks

---
Chun-Yeow
