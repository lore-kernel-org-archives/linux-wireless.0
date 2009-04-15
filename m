Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.186]:49269 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbZDOMMy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 08:12:54 -0400
Received: by mu-out-0910.google.com with SMTP id g7so1201938muf.1
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2009 05:12:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1239796656-20646-5-git-send-email-me@bobcopeland.com>
References: <1239796656-20646-1-git-send-email-me@bobcopeland.com>
	 <1239796656-20646-5-git-send-email-me@bobcopeland.com>
Date: Wed, 15 Apr 2009 15:12:49 +0300
Message-ID: <40f31dec0904150512q206c6811j153d7ea2c73fb0e4@mail.gmail.com> (sfid-20090415_141259_667155_37636FBE)
Subject: Re: [PATCH 4/5] ath5k: use rx hw descriptor pointer for self-linked
	check
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/15 Bob Copeland <me@bobcopeland.com>:
> This patch simplifies the code used to detect when the
> self-linked DMA buffer is still in use by hardware, by
> checking the hardware's rxdp register instead of looking
> at the software buffer list.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---

Acked-by: Nick Kossifidis <mickflemm@gmail.com>



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
