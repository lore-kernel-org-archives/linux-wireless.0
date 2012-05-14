Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:32810 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab2ENUxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 16:53:07 -0400
Received: by bkcji2 with SMTP id ji2so4216318bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 13:53:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FB15D76.9000302@lwfinger.net>
References: <4FB15D76.9000302@lwfinger.net>
Date: Mon, 14 May 2012 13:53:06 -0700
Message-ID: <CA++WF2M18LBx2OfKs47pr3=Z=yfOf43YEVv7-CshzMVrFcgmKg@mail.gmail.com> (sfid-20120514_225312_128036_B5E213D3)
Subject: Re: Warning from wireless-testing for ipw2100
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Larry,

On 14 May 2012 12:31, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> A freshly pulled copy of wireless-testing 3.4-rc7 has the following warning
> that the 802.11 band has not been set when the ipw2100 driver is probed:
> [   17.766431] ------------[ cut here ]------------
> [   17.766467] WARNING: at net/wireless/core.c:562
> wiphy_register+0x34c/0x3c0 [cfg80211]()

I think it is the same problem as for ipw2200 as found by Stefan
http://marc.info/?l=linux-wireless&m=132720334512946&w=2

which is already fixed.
http://marc.info/?l=linux-wireless&m=133457257407196&w=2

> ....
> I do not use the device and it doesn't make any difference to me, but there
> may be someone that needs it.

I will send a patch.

Stanislav.
