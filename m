Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34231 "EHLO
	mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbcGVEuR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2016 00:50:17 -0400
Received: by mail-it0-f65.google.com with SMTP id u186so2425745ita.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2016 21:50:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160721163107.686-1-me@bobcopeland.com>
References: <20160721163107.686-1-me@bobcopeland.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 22 Jul 2016 14:49:57 +1000
Message-ID: <CAGRGNgVRK_Cz9nFjDGXQWJonKuj-msB2MvS-RaJA1O3DK9fWnA@mail.gmail.com> (sfid-20160722_065037_117321_D33EEBE1)
Subject: Re: [PATCH] ath9k: fix misleading indent
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Fri, Jul 22, 2016 at 2:31 AM, Bob Copeland <me@bobcopeland.com> wrote:
> Fixes smatch warning:
>
> ath9k_vif_iter_set_beacon() warn if statement not indented
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Looks right to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

> ---
>  drivers/net/wireless/ath/ath9k/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
