Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f174.google.com ([209.85.128.174]:54949 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbaDXKOU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 06:14:20 -0400
Received: by mail-ve0-f174.google.com with SMTP id oz11so2586895veb.5
        for <linux-wireless@vger.kernel.org>; Thu, 24 Apr 2014 03:14:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <874n1jm54z.fsf@kamboji.qca.qualcomm.com>
References: <1398327250-12923-1-git-send-email-yeohchunyeow@gmail.com>
	<87d2g7m90w.fsf@kamboji.qca.qualcomm.com>
	<CAEFj986h0FtMOpbTbYYQzLxZrEcL_og0+qpQkfj36xMWM9LG5g@mail.gmail.com>
	<878uqvm7yz.fsf@kamboji.qca.qualcomm.com>
	<CAEFj986VVHkgSnv=xGo_WAYg+n4Sp0_qJGkpmzjNk9thoizZCA@mail.gmail.com>
	<874n1jm54z.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 24 Apr 2014 18:14:19 +0800
Message-ID: <CAEFj986mx-9UsV=PapWYmJf_vgkxAZowq9CbtguVHpKw-Er8cg@mail.gmail.com> (sfid-20140424_121437_525470_3C5D9E98)
Subject: Re: [PATCH] ath10k: don't allow stand alone monitor mode for non-AP firmware
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Yeah, maybe should change the documentation to recommend using 10.1
> branch for AP, STA and monitor modes? And recommended main branch only
> for Ad-Hoc and P2P?
>
Eventually, we need a single firmware that can support all the modes,
including mesh.

For the 10.1, it cited " STA specific features might not work". Can
someone comment what working and what not working?

----
Chun-Yeow
