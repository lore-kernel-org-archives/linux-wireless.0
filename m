Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:44429 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310Ab0CLKuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 05:50:16 -0500
Received: by bwz1 with SMTP id 1so908122bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 12 Mar 2010 02:50:14 -0800 (PST)
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 1/4 v2] wl1251: make local symbols static
References: <1268389721-3375-1-git-send-email-notasas@gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 12 Mar 2010 12:50:06 +0200
In-Reply-To: <1268389721-3375-1-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Fri\, 12 Mar 2010 12\:28\:41 +0200")
Message-ID: <87iq91ddb5.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> Make local functions and data static, also constify
> some structures. While at it, clean up unneeded includes.
>
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
> Cc: Bob Copeland <me@bobcopeland.com>

Thanks, looks good to me.

Acked-by: Kalle Valo <kalle.valo@iki.fi>

> John, I haven't added you to 'To:' when sent patches 2-4 of this
> series as SubmittingPatches requires (sent to the mailing list
> only), let me know in case I need to resend them.

My understanding is that sending them to the list is enough. At least
John has picked up my patches which I have sent to the list only.

-- 
Kalle Valo
