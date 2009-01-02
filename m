Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:19816 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbZABS7S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 13:59:18 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2307730fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jan 2009 10:59:15 -0800 (PST)
Message-ID: <69e28c910901021059q5bc604afn62117fcdf937d813@mail.gmail.com> (sfid-20090102_195921_740708_5BF1EBF0)
Date: Fri, 2 Jan 2009 19:59:15 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH] ath9k: Enable Bluetooth Coexistence support
Cc: "Vasanthakumar Thiagarajan" <vasanth@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Luis.Rodriguez@atheros.com, Jouni.Malinen@atheros.com,
	ath9k-devel@lists.ath9k.org
In-Reply-To: <200901021956.21785.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1230890746-3075-1-git-send-email-vasanth@atheros.com>
	 <69e28c910901021052m63f63a1ep704a4d8aa8b4ca9@mail.gmail.com>
	 <200901021956.21785.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 2, 2009 at 7:56 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Friday 02 January 2009 19:52:49 Stefanik G=E1bor wrote:
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
>
> And what makes you think that atheros also ships cards with broken bt=
coex support?

We can never know what vendors will do - or does Atheros only allow
reference card designs?
>
> --
> Greetings, Michael.
>



--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
