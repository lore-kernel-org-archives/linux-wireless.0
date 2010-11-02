Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46621 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0KBX5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 19:57:34 -0400
Received: by vws13 with SMTP id 13so347551vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Nov 2010 16:57:33 -0700 (PDT)
Message-ID: <4CD0A583.40105@lwfinger.net>
Date: Tue, 02 Nov 2010 18:57:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Rogerio Luz Coelho <rogluz.news@gmail.com>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/9] rtl8187: fix wrong register initialization in 8187B
References: <309278.75116.qm@web29520.mail.ird.yahoo.com>	<4CCF7B73.7040906@lwfinger.net>	<4CCF7EFC.1050000@mandriva.com.br> <AANLkTinEsp+-EU4Oau71qHbL6ftO544+H4GA3WZk7CX5@mail.gmail.com>
In-Reply-To: <AANLkTinEsp+-EU4Oau71qHbL6ftO544+H4GA3WZk7CX5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/02/2010 06:48 PM, Rogerio Luz Coelho wrote:
> Ok, I see the 8187b is in development.
> 
> But PLEASE ask Thadeu Cascardo for his patch as it seems to fix the
> issue with these cards when connected to Laptop (Positivo Laptops in
> Brasil for instance), this would even let the Mandriva folks show
> Positivo that they don't need to ship the Mandriva 2008.0 woith their
> Linux Laptops anymore ...
> 
> the patch he sent me FIXED the problem where the chip did not connect
> or when it did it would lose the connection right away...
> 
> see
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/215802?comments=all
> 
> 
> I haven´t aplied any other patches and the one he sent me JUST WORKS,
> tested in a Ubuntu 10.04 64bit (64bit being important since the
> Realtek support told me they did NOT support 64bit with their linux
> drivers)

Realtek does not support 64-bit systems with most of their drivers, but we do.
In fact, I only do development on x86_64 and then test on i386.

Obviously, there is something special about the Toshiba/Brazil devices. The
patch that you need to make a cdonnection had absolutely no effect on mine.

Larry

