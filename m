Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:61319 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826Ab3BZRuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 12:50:00 -0500
Received: by mail-bk0-f53.google.com with SMTP id j10so1966001bkw.40
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2013 09:49:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1302232342380.15538@icf.org.ru>
References: <1361648055-15871-1-git-send-email-kazikcz@gmail.com>
	<alpine.DEB.2.02.1302232342380.15538@icf.org.ru>
Date: Tue, 26 Feb 2013 18:49:58 +0100
Message-ID: <CABvG-CVVzBJ9M4VXq0HsNDyaDbcSWB-pmftXJYLKEg01zqHvDA@mail.gmail.com> (sfid-20130226_185006_550265_58026584)
Subject: Re: [PATCH] ath: sanitize 0xFFFF regdomain
From: =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
To: Georgiewskiy Yuriy <bottleman@icf.org.ru>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 February 2013 20:45, Georgiewskiy Yuriy <bottleman@icf.org.ru> wrote:
> hm, strange, i have this cards, and it's works fine, exactly not fine, but works,
> and as i known it's EOS since 2012.

Apparently some of them have their EEPROM programmed incorrectly.
Perhaps different revisions? Beats me.

The one in question has "F52N/F50N/F20N V7" printed on the board and
"FCC ID:VKV-Ff52N" on a sticker. Is yours any different?
