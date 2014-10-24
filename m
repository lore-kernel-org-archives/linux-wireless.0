Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:51057 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111AbaJXOXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 10:23:00 -0400
Received: by mail-la0-f42.google.com with SMTP id gf13so3038685lab.29
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2014 07:22:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87lho5muz6.fsf@kamboji.qca.qualcomm.com>
References: <1413823085-3187-1-git-send-email-yanbol@qti.qualcomm.com>
	<87lho5muz6.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 24 Oct 2014 22:22:59 +0800
Message-ID: <CAFuUQkj2Nn8TVQAHHUCNP+90zfUe0XSWWVQqVL_2C6bO524PVg@mail.gmail.com> (sfid-20141024_162305_873460_37EF1AD9)
Subject: Re: [PATCH v3] Add the target register read/write and memory dump
 debugfs interface
From: YanBo <dreamfly281@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Yanbo Li <yanbol@qti.qualcomm.com>, senthilb@qti.qualcomm.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 24, 2014 at 9:57 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>
> Yanbo Li <yanbol@qti.qualcomm.com> writes:
>
> > The debugfs interface reg_addr&reg_val used to read and write the target
> > register.
> > The interface mem_addr&mem_val used to dump the targer memory and also
> > can be used to assign value to target memory
>
> I think you got the mail from kbuild bot already, but this patch has a
> sparse warning:
>
> >> drivers/net/wireless/ath/ath10k/debug.c:1182:26: sparse: incorrect type in assignment (different base types)
>    drivers/net/wireless/ath/ath10k/debug.c:1182:26:    expected restricted __le32 [usertype] <noident>
>    drivers/net/wireless/ath/ath10k/debug.c:1182:26:    got unsigned int [unsigned] [addressable] [usertype] mem_val
>

Thanks for checking, will fix in local and submit again together with
Michal's suggestion.

BR /Yanbo
