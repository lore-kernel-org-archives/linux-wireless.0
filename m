Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:57158 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811Ab2BORyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 12:54:16 -0500
Received: by lahc1 with SMTP id c1so1381640lah.20
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 09:53:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XVqqfRF+4QtzxeknuvOyupEiNjzx4Cvjcv7DdPsvU1rA@mail.gmail.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-5-git-send-email-victorg@ti.com>
	<4F277FE3.8090006@sipsolutions.net>
	<CAK80WHaiOp2f08ErSiLdoSOcN1A1EbFX4x02wGPQY1WJJrKK-g@mail.gmail.com>
	<CAB=NE6XVqqfRF+4QtzxeknuvOyupEiNjzx4Cvjcv7DdPsvU1rA@mail.gmail.com>
Date: Wed, 15 Feb 2012 18:45:51 +0200
Message-ID: <CAK80WHYTRqH8LNV1uWgpX4vkBzCF8ogybFN6DicM3CdBWscVUw@mail.gmail.com> (sfid-20120215_185428_830508_3D9FEFD7)
Subject: Re: [RFC 4/9] mac80211: add ability to enable TX on op-channel
From: "Goldenshtein, Victor" <victorg@ti.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 10, 2012 at 12:36 AM, Luis R. Rodriguez
<mcgrof@frijolero.org> wrote:
> How about that and a CAC timer as sanity checks to cfg80211, not mac80211.
>

Please see my previous email.

-- 
Thanks,
Victor.
