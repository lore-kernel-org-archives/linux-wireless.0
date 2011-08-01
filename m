Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:52038 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab1HATit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2011 15:38:49 -0400
Received: by eye22 with SMTP id 22so4819742eye.2
        for <linux-wireless@vger.kernel.org>; Mon, 01 Aug 2011 12:38:48 -0700 (PDT)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Daniel Drake <dsd@laptop.org>
Subject: Re: [PATCH 1/2] libertas: disable functionality when interface is down
Date: Mon, 1 Aug 2011 22:38:17 +0300
Cc: libertas-dev@lists.infradead.org, linville@tuxdriver.com,
	dcbw@redhat.com, linux-wireless@vger.kernel.org
References: <20110801154313.8C9389D401F@zog.reactivated.net> <201108012213.13032.anarsoul@gmail.com> <CAGq3pz5xAZqofOJSanDfayabNd-i434QpAZFrKatui8WxMtBvQ@mail.gmail.com>
In-Reply-To: <CAGq3pz5xAZqofOJSanDfayabNd-i434QpAZFrKatui8WxMtBvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201108012238.18114.anarsoul@gmail.com> (sfid-20110801_213853_330595_DD0876B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 01 August 2011 22:19:12 Daniel Drake wrote:
> On 1 August 2011 20:13, Vasily Khoruzhick <anarsoul@gmail.com> wrote:
> > Cool, I hope I'll get some time tomorrow to test your changes with
> > libertas_spi.
> 
> Just to clarify, you won't see any power saving effects until you
> implement power_save and power_restore on the SPI level. See patch 2/2
> for how I did it for SDIO (it builds upon quite a bit of hard work
> implementing runtime power management in the MMC layer).

Yep, I understand. I sent pretty similar patch with same functionality some 
month ago, but it was not clean enough, and I had no time to clean it up. So I 
have almost all things ready, just need some tuning :)

Regards
Vasily
