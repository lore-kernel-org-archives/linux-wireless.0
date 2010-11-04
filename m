Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41813 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0KDOGY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 10:06:24 -0400
Received: by gyh4 with SMTP id 4so1389724gyh.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 07:06:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CD0BE99.8020409@lwfinger.net>
References: <309278.75116.qm@web29520.mail.ird.yahoo.com>
	<4CCF7B73.7040906@lwfinger.net>
	<4CCF7EFC.1050000@mandriva.com.br>
	<AANLkTinEsp+-EU4Oau71qHbL6ftO544+H4GA3WZk7CX5@mail.gmail.com>
	<4CD0A583.40105@lwfinger.net>
	<AANLkTin937V6hJ4L2o-SF5riTh0MpTd3e6faZnbZuV48@mail.gmail.com>
	<4CD0B0AC.4050102@lwfinger.net>
	<AANLkTinpJSKhf9PcG9bAPsLjVRKZ3bJEEK0-UQ4rpxJH@mail.gmail.com>
	<4CD0BE99.8020409@lwfinger.net>
Date: Thu, 4 Nov 2010 14:06:23 +0000
Message-ID: <AANLkTinSw9EDfqXaEbG9yhZ+G3ujC_ipBxx7gN5fBtn1@mail.gmail.com>
Subject: Re: [PATCH 3/9] rtl8187: fix wrong register initialization in 8187B
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Rogerio Luz Coelho <rogluz.news@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 3, 2010 at 1:44 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
<snipped>
> As I did something like 20 full kernel builds today, you know I do not use a
> distro that actively discourages kernel compilation. In fact I did run Ubuntu
> once to help a user debug a problem. After experiencing the hoops they make you
> jump through, I blew it away as soon as I could.

What hoops do they make you do? compiling a new kernel isn't really
much more than the normal development with GNU toolchain?

I only did full kernel compilation with my old 32-bit x86 slackware
box (and it died last year), but I found compat-wireless quite alright
on top of x64_64 fedora, even for developing/tryinng patches. (that's
thanks to Luis and John, of course).
