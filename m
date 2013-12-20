Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:35896 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab3LTH5f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Dec 2013 02:57:35 -0500
Received: by mail-ob0-f172.google.com with SMTP id gq1so2374969obb.31
        for <linux-wireless@vger.kernel.org>; Thu, 19 Dec 2013 23:57:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52B31392.2070705@broadcom.com>
References: <CAKH5=Lv=7CroQcx6x_JONnE+6mOTH1sLLcSxntGq2fogn-t4+Q@mail.gmail.com>
	<52B2E638.8060906@hauke-m.de>
	<CAKH5=LsaEw7GEHs5nb1omDeSMmcoFSXo8EEy+DeXvyXF5_1M_g@mail.gmail.com>
	<52B300FC.7070204@hauke-m.de>
	<52B31392.2070705@broadcom.com>
Date: Fri, 20 Dec 2013 08:57:34 +0100
Message-ID: <CACna6rwU8hroahpVsM7KTJD1iM2=12JuErr5LgCvswx+XsTjjA@mail.gmail.com> (sfid-20131220_085740_041168_90746CED)
Subject: Re: bcm43236 complient in the compat-wireless-3.6.81???
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Naughtboy <skylvlinux@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/12/19 Arend van Spriel <arend@broadcom.com>:
> It is in the kernel tree under
> 'drivers/net/wireless/brcm80211/brcmfmac'. We only support rev 3 because
> rev 2 and earlier do not have enough memory to run fullmac firmware.
> However, I have not found any rev 3 on the market. If you have please
> let me know.

Could you say something more about rev 2? How does it work with
internal Broadcom driver? Is the firmware stored somewhere else? Does
it have some another kind of memory?

Apart from the firmware storing issue, is the communication between
driver and hardware the same?
