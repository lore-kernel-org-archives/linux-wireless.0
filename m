Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46877 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358Ab1K1BJp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 20:09:45 -0500
Received: by vcbfk14 with SMTP id fk14so3245580vcb.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Nov 2011 17:09:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322439734-14520-1-git-send-email-mar.kolya@gmail.com>
References: <1322439734-14520-1-git-send-email-mar.kolya@gmail.com>
Date: Mon, 28 Nov 2011 09:09:44 +0800
Message-ID: <CAJ-Vmok08evQX-iZ3H2F3gmBGv2rfavp+4L3tezt-Rvp9Zu68A@mail.gmail.com> (sfid-20111128_020948_508238_285EDF32)
Subject: Re: [PATCH v2 0/4] Fix the way ANI is being handled for ar9100 and ar9340
From: Adrian Chadd <adrian@freebsd.org>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The reference HAL disables ANI for AR9130. I'm still waiting for an
answer as to why.

Thanks,


Adrian
