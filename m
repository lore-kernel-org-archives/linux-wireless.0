Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:50205 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbZDOMLZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 08:11:25 -0400
Received: by bwz17 with SMTP id 17so2868154bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2009 05:11:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1239796656-20646-3-git-send-email-me@bobcopeland.com>
References: <1239796656-20646-1-git-send-email-me@bobcopeland.com>
	 <1239796656-20646-3-git-send-email-me@bobcopeland.com>
Date: Wed, 15 Apr 2009 15:11:22 +0300
Message-ID: <40f31dec0904150511y498a23e8t24476844bcb715b0@mail.gmail.com> (sfid-20090415_141128_763680_4DF96D17)
Subject: Re: [PATCH 2/5] ath5k: use tasklet_hi_schedule for beacon queue
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/15 Bob Copeland <me@bobcopeland.com>:
> For embedded platforms, beacon transmission can be starved when
> flooded with data packets. =C2=A0Prioritize beacons by giving the bea=
con
> queue the first shot when the isr completes.
>
> Changes-licensed-under: 3-Clause-BSD
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>


Acked-by: Nick Kossifidis <mickflemm@gmail.com>





--=20
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
