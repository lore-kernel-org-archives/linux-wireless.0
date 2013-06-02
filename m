Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:55758 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953Ab3FBTiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Jun 2013 15:38:08 -0400
Received: by mail-ob0-f182.google.com with SMTP id va7so5970006obc.27
        for <linux-wireless@vger.kernel.org>; Sun, 02 Jun 2013 12:38:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130602144725.GC3875@shaftnet.org>
References: <1370126241-2528420-1-git-send-email-arnd@arndb.de>
	<20130602122954.GA3875@shaftnet.org>
	<8513280.folT80711V@wuerfel>
	<20130602144725.GC3875@shaftnet.org>
Date: Sun, 2 Jun 2013 21:38:07 +0200
Message-ID: <CACRpkdYPvGv6FAfm7VhdOkGZ_uXDgZv6v5CLjKjRQdqYOKLnvg@mail.gmail.com> (sfid-20130602_213812_135304_7EBB8F01)
Subject: Re: [PATCH] cw1200: fix some obvious mistakes
From: Linus Walleij <linus.walleij@linaro.org>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
	Ajitpal Singh <ajitpal.singh@stericsson.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 2, 2013 at 4:47 PM, Solomon Peachy <pizza@shaftnet.org> wrote:

>> In fact my mobile phone has a cw1200 chip that was working until
>> recently. Now it just crashes when I do 'ifconfig wlan0 up'
>> or enable WLAN in the Android settings menu. :(
>>
>> I'm not blaming you for that ;-)
>
> What model, out of curiousity?

FYI the CW1200 is used in for example:
http://en.wikipedia.org/wiki/Samsung_Galaxy_S_Advance
http://en.wikipedia.org/wiki/Samsung_Galaxy_S_III_Mini
http://en.wikipedia.org/wiki/Sony_Xperia_P
http://en.wikipedia.org/wiki/Sony_Xperia_U
http://en.wikipedia.org/wiki/Sony_Xperia_sola
(plus some others)

Yours,
Linus Walleij
