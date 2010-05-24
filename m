Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33343 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961Ab0EXRLn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 13:11:43 -0400
Received: by pwi2 with SMTP id 2so619943pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 May 2010 10:11:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BF7D69B.26828.A345D@jafojtik.seznam.cz>
References: <4BF7D69B.26828.A345D@jafojtik.seznam.cz>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 24 May 2010 10:11:23 -0700
Message-ID: <AANLkTikdtb0i-0k8dxVXiC8XgjkUOEflRk8w6qqLOa0N@mail.gmail.com>
Subject: Re: Problems with compilation "compat-wireless-2.6.34-rc4"
To: Jaroslav Fojtik <jafojtik@seznam.cz>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 22, 2010 at 6:05 AM, Jaroslav Fojtik <jafojtik@seznam.cz> wrote:
> Dears,
>
> It is interesting that compilation fails with misleading error
>  "cp: cannot create regular file `/lib/udev/rules.d/': Is a directory"
>
>  When I create a directory /lib/udev/rules.d/ manually, compilation
> runs normally. It would be a good idea to check existency of
> /lib/udev/rules.d/ e.g. insige "configure" script.
>
>
> make -C /usr/src/linux-2.6.32.11 M=/I/USR_SRC/compat-wireless-2.6.34-rc4 modules

Thanks for reporting this, I've fixed this, this will be propagated
into the compat-wireless-2.6.34.1 release.

  Luis
