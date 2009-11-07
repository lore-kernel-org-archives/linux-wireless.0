Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:49246 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZKGU0K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:26:10 -0500
Received: by iwn10 with SMTP id 10so1589428iwn.4
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2009 12:26:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 7 Nov 2009 12:25:56 -0800
Message-ID: <43e72e890911071225n72a19a8cia2f4e75ea7687d57@mail.gmail.com>
Subject: Re: [PATCH 00/29] ath: virtual wiphy updates / add ath9k_common
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 7, 2009 at 12:18 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:

> I've tested these changes with ath5k, ath9k and ar9170

I meant ar9271 of course :)

> on the ath9k_htc
> driver. ath9k_htc now scans with this common shared code.

the ar9271 I used is revision 0:

[ 3083.123570] phy3: Atheros AR9271 Rev:0
