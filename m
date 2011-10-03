Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60050 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab1JCL5d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 07:57:33 -0400
Received: by gyg10 with SMTP id 10so3304031gyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Oct 2011 04:57:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317637758-11907-4-git-send-email-zefir.kurtisi@neratec.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
	<1317637758-11907-4-git-send-email-zefir.kurtisi@neratec.com>
Date: Mon, 3 Oct 2011 19:57:32 +0800
Message-ID: <CAJ-VmonP5V2dL8aYiMRrkNcQR19kKAy2PCWHSkxb1biyJS7pow@mail.gmail.com> (sfid-20111003_135737_645084_073B7BEE)
Subject: Re: [RFC 3/6] ath9k: initial radar pulse detection for DFS
From: Adrian Chadd <adrian@freebsd.org>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, rodrigue@qca.qualcomm.com, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just out of curiousity, is there any "fast clock" on or off with the AR93xx ?

(That's one of the gotchas I came across when porting DFS code to
FreeBSD for the AR9160/AR9280.)

Thanks,


Adrian
