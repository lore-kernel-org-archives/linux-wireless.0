Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43094 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0KDOPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 10:15:25 -0400
Received: by ywc21 with SMTP id 21so1402462ywc.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 07:15:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTin937V6hJ4L2o-SF5riTh0MpTd3e6faZnbZuV48@mail.gmail.com>
References: <309278.75116.qm@web29520.mail.ird.yahoo.com>
	<4CCF7B73.7040906@lwfinger.net>
	<4CCF7EFC.1050000@mandriva.com.br>
	<AANLkTinEsp+-EU4Oau71qHbL6ftO544+H4GA3WZk7CX5@mail.gmail.com>
	<4CD0A583.40105@lwfinger.net>
	<AANLkTin937V6hJ4L2o-SF5riTh0MpTd3e6faZnbZuV48@mail.gmail.com>
Date: Thu, 4 Nov 2010 14:15:24 +0000
Message-ID: <AANLkTin_RYRFzFbsXrCLjT7Vq=uy4WrUtaKVi0=0R8Gj@mail.gmail.com>
Subject: Re: [PATCH 3/9] rtl8187: fix wrong register initialization in 8187B
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Rogerio Luz Coelho <rogluz.news@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 3, 2010 at 12:01 AM, Rogerio Luz Coelho
<rogluz.news@gmail.com> wrote:

>
> No effect is better than "regression" right?
>
> I am not saying the chip got magically better, it still seems a cheap
> POS, but with Cascardo's patch is as good as the Win7 driver here.

i'll have to read the Ubuntu launchpad thread a bit, but "no effect"
patches need to be clearly documented, etc because
(1) code stays in the kernel for a long time (years) and get modified,
re-factored, etc over time and one day somebody might need to
continue/modify/change a "no effect" patch and need to know why it was
included and what impact further changes.
(2) "no effect" really meant "no known effect" (yet).
