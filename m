Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbcESCIz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2016 22:08:55 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Dan Lenski <dlenski@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: increase polling timeout for firmware startup
References: <1463594249-19524-1-git-send-email-dlenski@gmail.com>
Date: Wed, 18 May 2016 22:08:53 -0400
In-Reply-To: <1463594249-19524-1-git-send-email-dlenski@gmail.com> (Dan
	Lenski's message of "Wed, 18 May 2016 10:57:28 -0700")
Message-ID: <wrfjinyayf2i.fsf@redhat.com> (sfid-20160519_040858_757042_C4FD1EC2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Lenski <dlenski@gmail.com> writes:
> Here is a patch to increase the polling timeout for rtl8xxxu firmware
> startup.
>
> This patch now applies cleanly to Jes Sorensen's rtl8xxxu-devel tree
> (86c89dd4782030c4f9e0c82424a8b92f9fdb35aa).
>
> The patch to make this a module parameter was removed.
>
> Dan Lenski (1):
>   rtl8xxxu: Increase default polling timeout for firmware startup
>
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Dan,

Thanks for the patch, I'll apply it shortly.

Cheers,
Jes
