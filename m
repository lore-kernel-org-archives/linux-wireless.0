Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:45555 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751389Ab2BOQrd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 11:47:33 -0500
Received: by mail-lpp01m010-f43.google.com with SMTP id p5so2178801lag.16
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 08:47:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6Vz0GX=XpcycGyGbsLYDt556BrW11P0RHEnCCOD9HB7XA@mail.gmail.com>
References: <1327581689-22090-1-git-send-email-victorg@ti.com>
	<1327581689-22090-2-git-send-email-victorg@ti.com>
	<CAB=NE6Vz0GX=XpcycGyGbsLYDt556BrW11P0RHEnCCOD9HB7XA@mail.gmail.com>
Date: Wed, 15 Feb 2012 18:47:23 +0200
Message-ID: <CAK80WHY+b-+Xs_htPVOXEDV3OuDJUzvfRy3TuvKPiHDdFjV3ow@mail.gmail.com> (sfid-20120215_174736_635275_B50412FB)
Subject: Re: [RFC 1/7] hostapd: implement dfs drv ops functions
From: "Goldenshtein, Victor" <victorg@ti.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, johannes@sipsolutions.net,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 10, 2012 at 1:19 AM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> No checks on if the channel is DFS, if we started DFS, etc?
>

Will add few sanity checks.

Thanks for the reviews ;)
Victor.
