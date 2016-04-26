Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48895 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbcDZJBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 05:01:51 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Radu P <rrrpan@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Intel 7260 AC only using 802.11n not AC
References: <CAL3+40H6tHomoXqAL=m7F5OT4X8+qAm7RGsUyCMw1=U6ROyqhg@mail.gmail.com>
Date: Tue, 26 Apr 2016 12:01:45 +0300
In-Reply-To: <CAL3+40H6tHomoXqAL=m7F5OT4X8+qAm7RGsUyCMw1=U6ROyqhg@mail.gmail.com>
	(Radu P.'s message of "Tue, 26 Apr 2016 08:20:08 +0100")
Message-ID: <87r3dswxom.fsf@purkki.adurom.net> (sfid-20160426_110157_860904_BD646E54)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Radu P <rrrpan@gmail.com> writes:

> These is the relevant data:
>
> firmware-version: 17.265642.0
>
> [  292.689871] iwlwifi 0000:04:00.0: loaded firmware version
> 17.265642.0 op_mode iwlmvm
> [  292.702902] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band
> Wireless AC 7260, REV=0x144
>
> wlan1     IEEE 802.11abgn <- not AC
>
> Kernel version: 4.4.0-21-generic #37~14.04.1-Ubuntu
>
> AC mode is working with Windows 10.

Don't use iwconfig, it's ancient and deprecated. Use iw instead.

-- 
Kalle Valo
