Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61452 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab1LIWxl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 17:53:41 -0500
Received: by ghbz2 with SMTP id z2so2959021ghb.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Dec 2011 14:53:41 -0800 (PST)
Message-ID: <4EE29171.9060608@lwfinger.net> (sfid-20111209_235344_875062_F0847360)
Date: Fri, 09 Dec 2011 16:53:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Performance of BCM43224 (14e4:4353)
References: <4EE15A4E.1090500@lwfinger.net> <4EE1E2AC.8030002@broadcom.com> <4EE23AF5.8000400@lwfinger.net> <4EE24615.9020003@broadcom.com> <4EE2509D.6020501@lwfinger.net> <4EE269CF.2000608@broadcom.com>
In-Reply-To: <4EE269CF.2000608@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/2011 02:04 PM, Arend van Spriel wrote:
>
> Indeed. What is more strange is that this looks like value from
> enumeration rom. 0x4bf is BCMA_MANUF_BCM, 0x800 is BCMA_CORE_CHIPCOMMON.
> It seems the BAR window is wrong. Can you read PCI_BAR window in the
> ai_doattach() before reading the chip id.

I would like a hint on how to do this. I tried some things that failed.

Larry
