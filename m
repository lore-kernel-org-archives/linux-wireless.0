Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46540 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab0KVQXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 11:23:47 -0500
Received: by vws13 with SMTP id 13so3461262vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 08:23:46 -0800 (PST)
Message-ID: <4CEA9903.6070604@lwfinger.net>
Date: Mon, 22 Nov 2010 10:23:31 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Klaas De Craemer <klaasdc@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: Re: RTL8187L: Can only "enable" hw radio switch after Windows boot
References: <AANLkTi=gzBDd6AZAzUKpLyTxtOgkwUkB5STeaU45=OFB@mail.gmail.com> <4CE997E3.9080706@lwfinger.net> <AANLkTi=kF956KYU393jmZhMagX=mz6dZcf1xwMaqPJ3Q@mail.gmail.com>
In-Reply-To: <AANLkTi=kF956KYU393jmZhMagX=mz6dZcf1xwMaqPJ3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/22/2010 02:59 AM, Klaas De Craemer wrote:
> 
> Sorry, I meant I get a few errors in the form of "SIOCSIFFLAGS:
> Unknown error 132" on the stdout when trying to bring up the blocked
> interface.

Do those errors also occur when it works, or just when it is blocked?

Is it possible to keep the box in a warm place to see if it is temperature
related? The problem of it working with Windows is still puzzling. As your Atom
is 32 bit, there is the possibility of trying ndiswrapper with the Windows XP
driver. Oh it hurts to write that, but that would isolate the problem to rtl8187.

Larry
