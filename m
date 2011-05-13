Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58563 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab1EMN1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 09:27:47 -0400
Received: by qyg14 with SMTP id 14so1459468qyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 06:27:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20110513T122134-409@post.gmane.org>
References: <AANLkTinBTXduB-uQp7FqNjPdzUm5=0v8vrE79oi5Toez@mail.gmail.com>
	<AANLkTikHx2J-zzCob+xVy04=RYX+K9T2HJ_14zyrto2J@mail.gmail.com>
	<loom.20110425T203659-857@post.gmane.org>
	<loom.20110513T122134-409@post.gmane.org>
Date: Fri, 13 May 2011 15:27:46 +0200
Message-ID: <BANLkTi=+odWsccvxF1uQ9ruUBDamoSG6hQ@mail.gmail.com> (sfid-20110513_152750_948538_4EDE1DEE)
Subject: Re: Broadcom 4331 wireless device
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: woto <oganer@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/5/13 woto <oganer@gmail.com>:
> Interesting too... :(

I just managed to add bcma driver (few days ago), now I have to add
support for bcma in b43. Without this we can not really think about
implementing BCM4331 support.

Still, even if we will have above part done, we need some reference
code/driver. AFAIK there is no Linux driver. Did you try using
ndiswrapper and Windows driver? Does it work?

-- 
Rafał
