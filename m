Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:50106 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755298Ab2BFPek (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 10:34:40 -0500
Received: by mail-lpp01m010-f44.google.com with SMTP id l5so3690623lah.31
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2012 07:34:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F2FE825.6020700@neratec.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-4-git-send-email-victorg@ti.com>
	<4F277F85.1090901@sipsolutions.net>
	<CAK80WHbAE0+NhLgLAxE+6BmkHFy2hw=sNV1TBjjOTajhHcdxRw@mail.gmail.com>
	<4F2B18AA.90809@neratec.com>
	<4F2FB6A0.5030901@gmail.com>
	<CAK80WHa_06axdbeOV33BKwOC9FPRZA_4xJeo0f6VOYVjqAcBHw@mail.gmail.com>
	<4F2FE825.6020700@neratec.com>
Date: Mon, 6 Feb 2012 17:34:39 +0200
Message-ID: <CAK80WHb11+p+=rsPNUbAPyPa+vVcFnc3FF6GaRswr3YQH48NEQ@mail.gmail.com> (sfid-20120206_163444_348028_A2E0F82E)
Subject: Re: [RFC 3/9] nl80211/cfg80211: add ability to enable TX on op-channel
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 6, 2012 at 4:48 PM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
> So the driver does not need to be aware of disabled TX condition at all, since hostapd ensures that no TX will happen during CAC? What is then your FLAG_DFS_CAC_IN_PROGRESS used for?
>

Additional protection prior starting the AP role.

> As for the naming, I'd maybe call them just dfs_start_cac() and dfs_end_cac(), but am also fine with the 'resume' variant.
>

Both this are also fine with me.


-- 
Victor.
