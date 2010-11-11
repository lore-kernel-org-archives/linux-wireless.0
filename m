Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39686 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab0KKR4i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 12:56:38 -0500
Received: by iwn10 with SMTP id 10so2431158iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 09:56:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1289477608.1606.43.camel@powerslave>
References: <1289215210-5276-1-git-send-email-shahar_levi@ti.com> <1289477608.1606.43.camel@powerslave>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 11 Nov 2010 09:56:14 -0800
Message-ID: <AANLkTimJJ1pa+3f6Ci64yu2qmtD_PxZvMJSKFF+0b_0R@mail.gmail.com>
Subject: Re: [PATCH v5] wl1271: Change wl12xx Files Names
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: Shahar Levi <shahar_levi@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 11, 2010 at 4:13 AM, Luciano Coelho
<luciano.coelho@nokia.com> wrote:
> On Mon, 2010-11-08 at 12:20 +0100, ext Shahar Levi wrote:
>> All files name prefix removed due to the fact that wl12xx driver supports
>> wl1271 and wl1273.
>> Also the definition in Kconfig and header files changed respectively.
>>
>> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
>> ---
>
> Applied and pushed, thank you!
>
> Luis, we're renaming also the wl1271 driver now, to wl12xx.  I remember
> when Kalle moved the wl1251 that there were some problems with
> compat-wireless.  Is there anything we need to do to keep things right
> in compat-wireless after this change?

Yeah

mcgrof@tux ~/devel/compat-wireless-2.6 (git::master)$ grep wl12xx/ patches/*
patches/06-header-changes.patch:--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
patches/06-header-changes.patch:+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
patches/25-multicast-list_head.patch:---
a/drivers/net/wireless/wl12xx/wl1271_main.c
patches/25-multicast-list_head.patch:+++
b/drivers/net/wireless/wl12xx/wl1271_main.c

That's likely all I think.

  Luis
