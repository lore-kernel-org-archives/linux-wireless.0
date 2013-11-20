Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:64863 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab3KTOIM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 09:08:12 -0500
Received: by mail-la0-f49.google.com with SMTP id er20so7221523lab.22
        for <linux-wireless@vger.kernel.org>; Wed, 20 Nov 2013 06:08:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2765421.8z1iAPSgk6@blech>
References: <2765421.8z1iAPSgk6@blech>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 20 Nov 2013 15:07:51 +0100
Message-ID: <CAB=NE6Vn5Pyn9k--S11SKsNS0VoK8BX0HXkdW8uR5u7D0yC4cQ@mail.gmail.com> (sfid-20131120_150815_871577_C7ED591C)
Subject: Re: [PATCH] reglib: fix memset usage
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 11, 2013 at 8:39 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> gcc-4.8 fails to compile reglib due to:
>
> reglib.c:1133:22: error: argument to ‘sizeof’ in ‘memset’ call is
>                          the same expression as the destination; did you mean
>                          to dereference it? [-Werror=sizeof-pointer-memaccess]
>   memset(rd, 0, sizeof(rd));
>                       ^
> reglib.c:1155:22: error: argument to ‘sizeof’ in... (same as above)
>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>

Thanks, applied and pushed!

  Luis
