Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:64355 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759401AbZKFQEG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 11:04:06 -0500
Received: by ywh40 with SMTP id 40so1014339ywh.33
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 08:04:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <m3k4y3wsla.wl%holgerschurig@gmail.com>
References: <loom.20091106T135746-452@post.gmane.org>
	 <loom.20091106T165330-596@post.gmane.org>
	 <m3k4y3wsla.wl%holgerschurig@gmail.com>
Date: Fri, 6 Nov 2009 11:04:10 -0500
Message-ID: <b6c5339f0911060804k565b5c7cm655374335c8b31fa@mail.gmail.com>
Subject: Re: [PATCH] Wifi led does not work on Acer Aspire One D250 (ath5k
	driver)
From: Bob Copeland <me@bobcopeland.com>
To: Holger Schurig <holgerschurig@googlemail.com>
Cc: Carlo Parata <carlo_parata@hotmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 6, 2009 at 11:01 AM, Holger Schurig
<holgerschurig@googlemail.com> wrote:
> lspci -vvnn gives all the gory details :-)
>

Yes, also to save you some trouble it looks like this patch
should already handle your device:

http://marc.info/?l=linux-wireless&m=125739131923457

(I guess from the XP info that you have 0x105b:e00d too)

-- 
Bob Copeland %% www.bobcopeland.com
