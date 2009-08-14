Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:33545 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbZHNQHY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 12:07:24 -0400
Message-ID: <20090814190724.12373pfrirqifq2o@hayate.sektori.org>
Date: Fri, 14 Aug 2009 19:07:24 +0300
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "=?iso-8859-1?b?R+Fib3I=?= Stefanik" <netrolller.3d@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Michael Buesch" <mb@bu3sch.de>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH v2 11/25] wireless: clarify rndis_wlan is not broadcom
	specific
References: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
	<1250210584-13374-12-git-send-email-lrodriguez@atheros.com>
	<69e28c910908140313p7d138635q51ee71c362aaa7f6@mail.gmail.com>
In-Reply-To: <69e28c910908140313p7d138635q51ee71c362aaa7f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Gábor Stefanik" <netrolller.3d@gmail.com>:

> On Fri, Aug 14, 2009 at 2:42 AM, Luis R.
> Rodriguez<lrodriguez@atheros.com> wrote:
>> Cc: Michael Buesch <mb@bu3sch.de>
>> Cc: Gábor Stefanik <netrolller.3d@gmail.com>
>> Cc: Johannes Berg <johannes@sipsolutions.net>
>> Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  drivers/net/wireless/Kconfig |    4 +++-
>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
>> index cb5aae6..a1bdb51 100644
>> --- a/drivers/net/wireless/Kconfig
>> +++ b/drivers/net/wireless/Kconfig
>> @@ -403,7 +403,9 @@ config USB_NET_RNDIS_WLAN
>>          BUFFALO WLI-USB-G54
>>
>>          All of these devices are based on Broadcom 4320 chip which is the
>> -         only wireless RNDIS chip known to date.
>> +         only wireless RNDIS chip known to date. Technically RNDIS follows
>> +         a specification and although only Broadcom currently supports this
>> +         other vendors could technically follow the implementation as well.
>
> To the aforementioned "other vendors" - please do not follow this
> brain-dead, Microsoft-based spec! :-)
>

Agreed!

-Jussi

