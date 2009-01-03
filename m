Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:44205 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZACUlF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 15:41:05 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2422097fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 03 Jan 2009 12:41:01 -0800 (PST)
Message-ID: <69e28c910901031241iaef37d5t2cb11bf867f75c86@mail.gmail.com> (sfid-20090103_214112_485062_7BC73DED)
Date: Sat, 3 Jan 2009 21:41:01 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Vasanthakumar Thiagarajan" <vasanth@atheros.com>
Subject: Re: [PATCH] ath9k: Enable Bluetooth Coexistence support
Cc: "Vasanth Thiagarajan" <Vasanth.Thiagarajan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"Jouni Malinen" <Jouni.Malinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
In-Reply-To: <20090103084637.GA31929@vasanth-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1230890746-3075-1-git-send-email-vasanth@atheros.com>
	 <69e28c910901021052m63f63a1ep704a4d8aa8b4ca9@mail.gmail.com>
	 <20090103084637.GA31929@vasanth-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 3, 2009 at 9:46 AM, Vasanthakumar Thiagarajan
<vasanth@atheros.com> wrote:
> On Sat, Jan 03, 2009 at 12:22:49AM +0530, Stefanik G=E1bor wrote:
>> On Fri, Jan 2, 2009 at 11:05 AM, Vasanthakumar Thiagarajan
>> <vasanth@atheros.com> wrote:
>> > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
>> > ---
>> >  drivers/net/wireless/ath9k/ath9k.h |    5 +++++
>> >  drivers/net/wireless/ath9k/hw.c    |   33 +++++++++++++++++++++++=
++++++++++
>> >  drivers/net/wireless/ath9k/main.c  |    9 +++++++--
>> >  drivers/net/wireless/ath9k/reg.h   |   10 ++++++++++
>> >  4 files changed, 55 insertions(+), 2 deletions(-)
>> >
>> > <snip>
>>
>> Probably a NOBTCOEX modparam might be a good idea - when implementin=
g
>> BT coexistence in b43, a lot of non-BT-aware cards failed to work
>> because the BT GPIO line was connected to the TX preamplifier,
>> breaking all TX.
>
> No need for any module parameters for enabling BT coex. It is
> already running without any issue on Windows Vista.
>
> Vasanth
>>
>> --
>> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-=
)
>

Broadcom's BT coex was also running correctly on Windows Vista, but it
still caused problems on Linux.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
