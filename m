Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:36684 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600Ab2FYKqf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 06:46:35 -0400
Message-ID: <4FE84184.4090601@neratec.com> (sfid-20120625_124639_222171_0063A988)
Date: Mon, 25 Jun 2012 12:46:28 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"Chadd, Adrian" <achadd@qca.qualcomm.com>,
	Benoit Papillault <benoit.papillault@free.fr>,
	Felix Fietkau <nbd@openwrt.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: [ANN] DFS testing: use USRP-Radar-Relay for SDR radar pattern generation
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello DFS folks,

now that DFS support is emerging in linux-wireless, we have quite some
testing ahead.

Testing DFS towards certification at physical layer requires laboratory
equipment that is very expensive (often going into the 6-digit US$
range) and makes it non-affordable for independent developers or smaller
companies.

We evaluated a SDR (software defined radio) approach and found it to be
a very well usable alternative for exorbitant dedicated radar generating
equipment. Our approach uses an Ettus research USRP N200 device to
continuously stream radar patterns as waveforms in the time domain to be
radiated to the attached wiphy.

The SW that abstracts the SDR and the generation of samples for a given
radar pattern is open sourced and available at [1]. With the
'USRP-Radar-Relay' SW and SDR you can have a highly customizable and
flexible radar generating device for less than 2k$ - a definitely lower
barrier to decentralize DFS testing.


Cheers,
Zefir


[1] https://github.com/zefir-kurtisi/USRP-Radar-Relay
