Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:34065 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1HKAOP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 20:14:15 -0400
Received: by pzk37 with SMTP id 37so2698680pzk.1
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 17:14:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313001339-11211-2-git-send-email-zajec5@gmail.com>
References: <1313001339-11211-1-git-send-email-zajec5@gmail.com>
	<1313001339-11211-2-git-send-email-zajec5@gmail.com>
Date: Thu, 11 Aug 2011 02:14:14 +0200
Message-ID: <CACna6rynj+OXL1R6jwgnCzReuO+=piOX3LTC9UujDTg4DNBVUw@mail.gmail.com> (sfid-20110811_021420_952130_1D402803)
Subject: Re: [RFC][RFT][PATCH V2 2/2] b43: fix DMA on some bugged hardware
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 10 sierpnia 2011 20:35 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> Some hardware with 64-bit DMA uses lower address word for setting
> routing (translation) bit. Add workaround for such boards.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> This requires testing on at least 1 normal 64-bit DMA card and 1 32-bit
> DMA card. So far it was tested only on my 14e4:4329 where it fixed DMA.

14e4:4353 (BCM43224), 64-bit DMA, still works :)

The rest will follow tomorrow.

-- 
Rafał
