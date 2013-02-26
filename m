Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.236.10]:45388 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab3BZSMH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 13:12:07 -0500
Date: Tue, 26 Feb 2013 22:12:00 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: =?ISO-8859-2?Q?Micha=B3_Kazior?= <kazikcz@gmail.com>
cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: Re: [PATCH] ath: sanitize 0xFFFF regdomain
In-Reply-To: <CABvG-CVVzBJ9M4VXq0HsNDyaDbcSWB-pmftXJYLKEg01zqHvDA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1302262208260.13622@icf.org.ru> (sfid-20130226_191211_553968_781816CC)
References: <1361648055-15871-1-git-send-email-kazikcz@gmail.com> <alpine.DEB.2.02.1302232342380.15538@icf.org.ru> <CABvG-CVVzBJ9M4VXq0HsNDyaDbcSWB-pmftXJYLKEg01zqHvDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1050998036-690646527-1361902320=:13622"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1050998036-690646527-1361902320=:13622
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On 2013-02-26 18:49 +0100, Micha? Kazior wrote Georgiewskiy Yuriy:

MK>On 23 February 2013 20:45, Georgiewskiy Yuriy <bottleman@icf.org.ru> wrote:
MK>> hm, strange, i have this cards, and it's works fine, exactly not fine, but works,
MK>> and as i known it's EOS since 2012.
MK>
MK>Apparently some of them have their EEPROM programmed incorrectly.
MK>Perhaps different revisions? Beats me.
MK>
MK>The one in question has "F52N/F50N/F20N V7" printed on the board and
MK>"FCC ID:VKV-Ff52N" on a sticker. Is yours any different?

hm, may be, have f52n/f50n/f20n next line 
1132 v6 он the board, and have no any FCC on sticker, seems only serial 
number or something like this on it.

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1050998036-690646527-1361902320=:13622--
