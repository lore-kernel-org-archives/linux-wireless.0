Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59894 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab1JCOXg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 10:23:36 -0400
Received: by yxl31 with SMTP id 31so3521038yxl.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Oct 2011 07:23:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E89C4F1.2090708@neratec.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
	<1317637758-11907-4-git-send-email-zefir.kurtisi@neratec.com>
	<CAJ-VmonP5V2dL8aYiMRrkNcQR19kKAy2PCWHSkxb1biyJS7pow@mail.gmail.com>
	<4E89A941.8060208@neratec.com>
	<CAJ-Vmomx8eSBTEZ3A_vnw8GaWh2dO3CFD-MZ6zzBDmWKZx7=xw@mail.gmail.com>
	<4E89C4F1.2090708@neratec.com>
Date: Mon, 3 Oct 2011 22:23:35 +0800
Message-ID: <CAJ-VmokCgNM650p7JRrka_5U-OqZzpcKewfPqqEudc5DNxhR0g@mail.gmail.com> (sfid-20111003_162339_252829_2F56C7E3)
Subject: Re: [RFC 3/6] ath9k: initial radar pulse detection for DFS
From: Adrian Chadd <adrian@freebsd.org>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, rodrigue@qca.qualcomm.com, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 October 2011 22:21, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:


> Most probably it'll end being added to the lengthy TODO list.

:) No worries. I've just added the freebsd version of this to
FreeBSD-HEAD. I'll add in the duration calculation function soon.

Now all we need is an ISC/GPL dual licenced packet classification
module. *wink* :)


Adrian
