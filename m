Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:39128 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbZDOMLs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 08:11:48 -0400
Received: by fxm2 with SMTP id 2so2871341fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2009 05:11:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1239796656-20646-4-git-send-email-me@bobcopeland.com>
References: <1239796656-20646-1-git-send-email-me@bobcopeland.com>
	 <1239796656-20646-4-git-send-email-me@bobcopeland.com>
Date: Wed, 15 Apr 2009 15:11:46 +0300
Message-ID: <40f31dec0904150511m7f2bb80bn62431b098a4e7374@mail.gmail.com> (sfid-20090415_141151_088884_58AB943A)
Subject: Re: [PATCH 3/5] ath5k: use bool for modparams
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/15 Bob Copeland <me@bobcopeland.com>:
> Current code uses int types, but both modparams are boolean values.
>
> Changes-licensed-under: 3-Clause-BSD
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---


Acked-by: Nick Kossifidis <mickflemm@gmail.com>




-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
