Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50436 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933446Ab0LUDHJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 22:07:09 -0500
Received: by vws16 with SMTP id 16so1593843vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 19:07:08 -0800 (PST)
Message-ID: <4D1019DC.8000004@lwfinger.net>
Date: Mon, 20 Dec 2010 21:07:08 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Amos Blanton <amos.blanton@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8192 does not see N networks in my building
References: <AANLkTikKtc4uiXN+oHwDr8sPFXZCe3HvTfYSvgZ8uYx0@mail.gmail.com>	<4D0BADBE.40101@lwfinger.net>	<AANLkTimvazto71m6SPMYtSAGuQkNpab+kMZcF4buNqYa@mail.gmail.com>	<4D0BC0C1.4000809@lwfinger.net>	<AANLkTinCWK95_eFb47pFLz2O=+UHMGpeXg9Z_JstFEa=@mail.gmail.com> <AANLkTinWZ_1EQTJsWrPmUJEqFpEg8JEOkcOtKZXbqJr7@mail.gmail.com>
In-Reply-To: <AANLkTinWZ_1EQTJsWrPmUJEqFpEg8JEOkcOtKZXbqJr7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/20/2010 09:49 AM, Amos Blanton wrote:
> Ok, I did the lwist scan properly this time. And wow, we have a lot of
> wifi here - 96 cells in fact.
> The list has most of the visible networks that others can see in the
> area with the exception of MIT N, which is the one that works decently
> well.  There's also MIT Secure N, which it doesn't see either. So I
> guess the device is not finding any N networks?
> 
> Would this be something I should report to RealTek?
> Thanks very much for your help with this.

You probably should report it to Reaktek. I'm not sure what response you might get.

If you find another Linux system that has connected to one of these routers
using an 802.11 b/g card, I would be interested in seeing the output of iwconfig
for that computer.

Larry

