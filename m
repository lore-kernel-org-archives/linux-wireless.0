Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52619 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab0LDQio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Dec 2010 11:38:44 -0500
Received: by qwb7 with SMTP id 7so10775540qwb.19
        for <linux-wireless@vger.kernel.org>; Sat, 04 Dec 2010 08:38:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikccdMeLE-V2-pATqzj8mg3DKyN7SVCi-RX-vdn@mail.gmail.com>
References: <AANLkTi=6NGw3GTnX+vEqx_iHcDb4SUmPc5vvndyMc=5s@mail.gmail.com>
 <AANLkTinMBx=5J4ZAaO7qkmJAxp4xbjoJxq+m+Bjz+K1e@mail.gmail.com>
 <AANLkTimUpxb+qaCerwgxqcz5iOmFz7MaZFhFPSOxJd1M@mail.gmail.com>
 <AANLkTikCrcpbyNEL94Jo9OsvcaEguKfN6-9nheZ=Sa8Q@mail.gmail.com>
 <AANLkTikcngkX=a24r=uQKXgBjABQzZn_Hz3H2bvuiU8e@mail.gmail.com> <AANLkTikccdMeLE-V2-pATqzj8mg3DKyN7SVCi-RX-vdn@mail.gmail.com>
From: Joerie de Gram <j.de.gram@gmail.com>
Date: Sat, 4 Dec 2010 17:38:22 +0100
Message-ID: <AANLkTim8YHX-oHbPCMESV6XjTNwaJNt56irNMVnFQhT0@mail.gmail.com>
Subject: Re: wl1271: power down/up sequence
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Dec 2, 2010 at 5:23 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> You forgot to apply 516d5cc "mmc: add runtime PM handlers":

Problem solved, it appears to work just fine now. Thanks (again).

Joerie
