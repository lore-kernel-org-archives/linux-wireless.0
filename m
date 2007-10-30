Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:25454 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbXJ3QpV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2007 12:45:21 -0400
Received: by py-out-1112.google.com with SMTP id u77so3649345pyb
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2007 09:45:19 -0700 (PDT)
Message-ID: <43e72e890710300945r41bd982bife52835660ff0c10@mail.gmail.com> (sfid-20071030_164526_101435_3FDD7639)
Date: Tue, 30 Oct 2007 12:45:18 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: Re: [PATCH] ath5k: Remove fill_tx_desc
In-Reply-To: <20071027235827.GH5973@localhost.domain.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071027235827.GH5973@localhost.domain.invalid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/27/07, Nick Kossifidis <mick@madwifi.org> wrote:
> fill_tx_desc is used for fast frames operation, since
> we don't support fast frames (and since fill_tx_desc
> had a bug -thanx to Ulrich Meis for finding that out-)
> these functions are not needed (+ they are misleading
> because they don't "fill" any tx descriptor).
>
> I couldn't test this patch much so plz someone ACK it...
>
> It applies on top of my previous patches (i just thought
> that [PATCH 8/7] won't look nice ;-) ).
>
>
> Changes-licensed-under: ISC
> Signed-off-by: Ulrich Meis <meis@nets.rwth-aachen.de>
> Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

Very nice, I've been testing this on 2.6.24-rc1 for a day without
problems. I'll soon post results of of all your patches and your 1-7
series on big endian. Compiling takes a while there, heh.. I guess I
should be cross compiling huh.

  Luis
