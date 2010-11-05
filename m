Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:33143 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab0KEUaw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 16:30:52 -0400
Received: by qyk10 with SMTP id 10so3022862qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Nov 2010 13:30:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTin_RYRFzFbsXrCLjT7Vq=uy4WrUtaKVi0=0R8Gj@mail.gmail.com>
References: <309278.75116.qm@web29520.mail.ird.yahoo.com>
	<4CCF7B73.7040906@lwfinger.net>
	<4CCF7EFC.1050000@mandriva.com.br>
	<AANLkTinEsp+-EU4Oau71qHbL6ftO544+H4GA3WZk7CX5@mail.gmail.com>
	<4CD0A583.40105@lwfinger.net>
	<AANLkTin937V6hJ4L2o-SF5riTh0MpTd3e6faZnbZuV48@mail.gmail.com>
	<AANLkTin_RYRFzFbsXrCLjT7Vq=uy4WrUtaKVi0=0R8Gj@mail.gmail.com>
Date: Fri, 5 Nov 2010 18:30:51 -0200
Message-ID: <AANLkTin_T_SNkksOFmtjKgah0o0o1vZgpf=R4kEryQ_F@mail.gmail.com>
Subject: Re: [PATCH 3/9] rtl8187: fix wrong register initialization in 8187B
From: Rogerio Luz Coelho <rogluz.news@gmail.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/4 Hin-Tak Leung <hintak.leung@gmail.com>:
> On Wed, Nov 3, 2010 at 12:01 AM, Rogerio Luz Coelho
> <rogluz.news@gmail.com> wrote:
>
>>
>> No effect is better than "regression" right?
>>
>> I am not saying the chip got magically better, it still seems a cheap
>> POS, but with Cascardo's patch is as good as the Win7 driver here.
>
> i'll have to read the Ubuntu launchpad thread a bit, but "no effect"
> patches need to be clearly documented, etc because
> (1) code stays in the kernel for a long time (years) and get modified,
> re-factored, etc over time and one day somebody might need to
> continue/modify/change a "no effect" patch and need to know why it was
> included and what impact further changes.
> (2) "no effect" really meant "no known effect" (yet).
>
But that's the point ... no effect to Larry that has an external card
is ok, but for my internal card the patch made everything better (more
so, now the box is useable again), so even if it is just 1 person (or
vendor) if the patch is "no effect" for the rest of the functionality
it should be added to mainline (al least IMHO)

Rogerio
