Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:63447 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758053AbYF0SaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 14:30:19 -0400
Received: by rv-out-0506.google.com with SMTP id k40so683273rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jun 2008 11:30:19 -0700 (PDT)
Message-ID: <b6c5339f0806271130r608ff144o44a34ff43c984a62@mail.gmail.com> (sfid-20080627_203024_852331_C616C2BB)
Date: Fri, 27 Jun 2008 14:30:19 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath5k: remove now unused variable declared in ath5k_tx
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1214579450-14470-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214579450-14470-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 27, 2008 at 11:10 AM, John W. Linville
<linville@tuxdriver.com> wrote:
>  CC [M]  drivers/net/wireless/ath5k/base.o
> drivers/net/wireless/ath5k/base.c: In function 'ath5k_tx':
> drivers/net/wireless/ath5k/base.c:2598: warning: unused variable 'info'
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Oops, thanks for the pickup.  Not sure why I didn't get that one.

-- 
Bob Copeland %% www.bobcopeland.com
