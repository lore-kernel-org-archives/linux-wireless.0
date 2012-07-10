Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43838 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab2GJKLE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 06:11:04 -0400
Received: by gglu4 with SMTP id u4so11051717ggl.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2012 03:11:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341834481-1831-1-git-send-email-ozancag@gmail.com>
References: <1341834481-1831-1-git-send-email-ozancag@gmail.com>
Date: Tue, 10 Jul 2012 13:11:03 +0300
Message-ID: <CAFub=KTDYF71=GiEMAdVNDTKeMMZYFy4C0YqPpvhOE-+MShrKQ@mail.gmail.com> (sfid-20120710_121108_267881_1B4E34E6)
Subject: Re: [PATCH] compat: Fix setting $TARGET
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 9, 2012 at 2:48 PM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> commit 61077651424add644401b927b52681a191bbd7f1 moved the list of
> kernels above which broke the $TARGET substitutions in them.
>
> Move the TARGET detection above of everything to fix this.
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

I think you missed this as you've pushed the other 2 patches :)
