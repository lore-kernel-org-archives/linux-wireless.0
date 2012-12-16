Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33300 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2LPDsF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2012 22:48:05 -0500
Received: by mail-vb0-f46.google.com with SMTP id b13so5818897vby.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Dec 2012 19:48:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50CA5EE9.30606@openwrt.org>
References: <1354811768-4414-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	<20121213140753.GA26868@pandem0nium>
	<50CA0F8B.3060905@openwrt.org>
	<20121213220651.GA30855@pandem0nium>
	<50CA5EE9.30606@openwrt.org>
Date: Sat, 15 Dec 2012 19:48:02 -0800
Message-ID: <CAJ-VmokcJUBZeOAyjaNefqgtEkdjGFhH3NQEXA38Xe_i2M+wYA@mail.gmail.com> (sfid-20121216_044844_524492_A4976EA5)
Subject: Re: [RFCv2] Add spectral scan support for Atheros AR92xx/AR93xx
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	jonbither@gmail.com, jouni@qca.qualcomm.com,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let's just get the API working and expose those frames to userland;
then we can start playing with things in more depth.

I'll go dig up the radar FFT formats too in a minute and see what I can do.



Adrian
