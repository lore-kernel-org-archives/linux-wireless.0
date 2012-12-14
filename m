Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37984 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745Ab2LNAbB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 19:31:01 -0500
Received: by mail-we0-f174.google.com with SMTP id x10so1205814wey.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 16:31:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50CA71A4.1010806@net.t-labs.tu-berlin.de>
References: <1354811768-4414-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	<20121213140753.GA26868@pandem0nium>
	<50CA0F8B.3060905@openwrt.org>
	<20121213220651.GA30855@pandem0nium>
	<50CA5EE9.30606@openwrt.org>
	<50CA71A4.1010806@net.t-labs.tu-berlin.de>
Date: Thu, 13 Dec 2012 16:30:59 -0800
Message-ID: <CAJ-Vmonq0kw9_yvub0HXQXJvP6HKhVD81gfo+ttKgyxo1rdG=Q@mail.gmail.com> (sfid-20121214_013117_917121_AE69DB1C)
Subject: Re: [RFCv2] Add spectral scan support for Atheros AR92xx/AR93xx
From: Adrian Chadd <adrian@freebsd.org>
To: Tobias Steinicke <tobias.steinicke@net.t-labs.tu-berlin.de>
Cc: Felix Fietkau <nbd@openwrt.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	jonbither@gmail.com, jouni@qca.qualcomm.com,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

So the payload length will be based on HT20 vs HT40, but also the
spectral scan FFT config. You can specify how many samples to take
each time and whether to gather them "short" or "not short" time
interval.

So fiddle around with the number of samples in the FFT config and
you'll see different sized payloads.

Since Felix has just posted the spectral scan FFT format, we may as
well post the radar FFT format. :)



Adrian
