Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:59140 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933191AbZHVV7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 17:59:32 -0400
Received: by ewy3 with SMTP id 3so1478292ewy.18
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2009 14:59:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200908220038.35564.herton@mandriva.com.br>
References: <200908220038.35564.herton@mandriva.com.br>
Date: Sat, 22 Aug 2009 22:59:33 +0100
Message-ID: <3ace41890908221459j70e31c20ufa5ea03973a16e0a@mail.gmail.com>
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 22, 2009 at 4:38 AM, Herton Ronaldo
Krzesinski<herton@mandriva.com.br> wrote:
> This change implements rfkill support for RTL8187B and RTL8187L devices,
> using new cfg80211 rfkill API.
>
> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>

Neat!

I ran a ping to the router while flicking the switch on and off, and
have 'ping: sendmsg: Network is unreachable' in the middle. dmesg also
shows

rtl8187: wireless radio switch turned off
wlan2: deauthenticating by local choice (reason=3)
rtl8187: wireless radio switch turned on

etc. Work as advertised.

Well done!

Hin-Tak
