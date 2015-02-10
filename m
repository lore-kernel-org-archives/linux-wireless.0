Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:41224 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbbBJI1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2015 03:27:14 -0500
Received: by iecrd18 with SMTP id rd18so10890713iec.8
        for <linux-wireless@vger.kernel.org>; Tue, 10 Feb 2015 00:27:13 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 10 Feb 2015 09:27:13 +0100
Message-ID: <CADnKcViRWR1Ex-=QGzROQGYKNcZLMSu+mLDJ8-KhUuf=acDXdQ@mail.gmail.com> (sfid-20150210_092718_118236_74E1F65E)
Subject: Re: [PATCH] ath10k: fix wmm params per vdev
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 February 2015 at 14:41, Marek Puzyniak <marek.puzyniak@tieto.com> wrote:
> During wmm tests changing wmm parameters did not change anything.
> This was because of mismatch in WMM params per vdev command.
> WMM params per vdev uses different command structure than wmm params
> per pdev command. Also txop for per vdev settings has the
> same units as provided by mac80211.
>
> Patch concerns qca6174.
>
> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>

Kalle,

Please do not merge this patch yet. I need to clarify some side effects.
I will inform you about next steps.

Thanks,
Marek
