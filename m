Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:36671 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbZJ0Tj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 15:39:27 -0400
Received: by ewy4 with SMTP id 4so58334ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2009 12:39:31 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl1251: re-disable PG10 chips
References: <1256671025-26126-1-git-send-email-linville@tuxdriver.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 27 Oct 2009 21:39:29 +0200
In-Reply-To: <1256671025-26126-1-git-send-email-linville@tuxdriver.com> (John W. Linville's message of "Tue\, 27 Oct 2009 15\:17\:05 -0400")
Message-ID: <87vdi0fwy6.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> "wl1251: add support for PG11 chips." accidentally enabled PG10 chips as
> well...
>
> Reported-by: Kalle Valo <kalle.valo@iki.fi>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Thanks, looks good.

-- 
Kalle Valo
