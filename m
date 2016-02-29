Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:35309 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbcB2Xsi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 18:48:38 -0500
Received: by mail-io0-f194.google.com with SMTP id n190so103566iof.2
        for <linux-wireless@vger.kernel.org>; Mon, 29 Feb 2016 15:48:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456783551-28315-112-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com> <1456783551-28315-112-git-send-email-Jes.Sorensen@redhat.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 1 Mar 2016 10:48:17 +1100
Message-ID: <CAGRGNgWmnQMRbDzBTDp36DY96Svy_phVBASNHE8frp51O1S20g@mail.gmail.com> (sfid-20160301_004840_905260_5D02ED2E)
Subject: Re: [PATCH 111/113] rtl8xxxu: Print a warning if flushing the FIFO fails
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jes,

On Tue, Mar 1, 2016 at 9:05 AM,  <Jes.Sorensen@redhat.com> wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> Only print a warning if the FIFO flush fails, as opposed to printing
> the status unconditionally.
>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Should this be squashed into the previous patch?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
