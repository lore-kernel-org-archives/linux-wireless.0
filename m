Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:33490 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbZK2E7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 23:59:54 -0500
Received: by iwn1 with SMTP id 1so1579804iwn.33
        for <linux-wireless@vger.kernel.org>; Sat, 28 Nov 2009 21:00:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1259468182-25499-1-git-send-email-HinTak.Leung@gmail.com>
References: <1259468182-25499-1-git-send-email-HinTak.Leung@gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sat, 28 Nov 2009 20:59:41 -0800
Message-ID: <43e72e890911282059w5857b0b9ic9b0c2ca01625d7d@mail.gmail.com>
Subject: Re: [PATCH] compat-2.6: split netdev patch to libertas/main.c into
	two parts
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 28, 2009 at 8:16 PM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> Split netdev patch to libertas/main.c into two parts, one for
> libertas/main.c and one for libertas/mesh.c, because of the file itself
> was split in commit in wireless-testing:
>
> commit a4c65e7720b22d0fa76da3b6d00a00bcffd036ab
> Author: Holger Schurig <holgerschurig@gmail.com>
> Date:   Wed Nov 25 13:10:15 2009 +0100
>
>    libertas: moveing mesh-related functions into mesh.c
>
> Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
>
> ---

applied thanks
