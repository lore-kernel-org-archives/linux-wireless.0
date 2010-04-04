Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:35648 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab0DDAUg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Apr 2010 20:20:36 -0400
Received: by wwb17 with SMTP id 17so1937084wwb.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Apr 2010 17:20:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BB773A9.2070703@lwfinger.net>
References: <u2u917a57cb1004030656w7aff9e18qa43a358674d52d5a@mail.gmail.com>
	 <4BB7660A.3030900@lwfinger.net>
	 <i2x917a57cb1004030949qabd49dfeqa1f7cb66f4ef0f4e@mail.gmail.com>
	 <4BB773A9.2070703@lwfinger.net>
Date: Sun, 4 Apr 2010 01:20:34 +0100
Message-ID: <u2o3ace41891004031720ha68d9367m4be78c2a5d850f89@mail.gmail.com>
Subject: Re: RTL 8187b - naughty behaviour
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Rogerio Luz Coelho <rogluz.news@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 3, 2010 at 5:58 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
<snipped>
> What is the exact make and model of the device? It might be difficult
> for me to get one in the US, but one of the rtl8187 developers lives in
> Brazil. He should be able to find one.

Herton might be able to get the exact model/etc from Brazil so it is
worth providing the vendor details.

I am also wondering if it would help changing the rate-changing
algorithm, seeing as Minstrel became the default around 2.6.32, and
there has been a couple of reports about minstrel not working as well
as pid for weak APs. (
https://bugzilla.kernel.org/show_bug.cgi?id=14168 )
