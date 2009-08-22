Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:46440 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbZHVWGm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 18:06:42 -0400
Received: by ewy3 with SMTP id 3so1480597ewy.18
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2009 15:06:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A8E9315.3000709@lwfinger.net>
References: <200908202116.17847.herton@mandriva.com.br>
	 <4A8DF356.8000501@lwfinger.net>
	 <3ace41890908202054j62fda37ei64262890c6959f95@mail.gmail.com>
	 <4A8E9315.3000709@lwfinger.net>
Date: Sat, 22 Aug 2009 23:06:43 +0100
Message-ID: <3ace41890908221506k4c056a1bt3836bd026951e8dd@mail.gmail.com>
Subject: Re: [PATCH] rtl8187: always set MSR_LINK_ENEDCA flag with RTL8187B
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 21, 2009 at 1:29 PM, Larry Finger<Larry.Finger@lwfinger.net> wrote:
> Hin-Tak Leung wrote:
>>

> This problem was quite strange. My system would fail when the RTL8187B
> was inserted when the system booted. Unloading the driver did not
> help, but removing/reinstalling the card fixed the problem. As all my
> testing had been to install the card after booting, I never saw the
> failure.

Removing/reinstalling the card also reset the usb hub driver, I think,
and does more than unloading the driver. I don't have that ability
(rtl8187 built-in), but suspend/resume on my system also works around
the 'can't load 2nd time' problem.

Anyway, the 'can't load compat-wireless 2nd time' problem seems to
have gone away - I just loaded it a 2nd time testing the rkfill patch.

Hin-Tak
