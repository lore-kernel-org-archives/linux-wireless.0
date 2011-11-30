Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:57229 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab1K3Gr4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 01:47:56 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: validate for non-zero BSSID
References: <1322576540-13751-1-git-send-email-mohammed@qca.qualcomm.com>
	<20111130023650.19520.qmail@stuge.se>
	<4ED5BD76.7020204@qca.qualcomm.com>
Date: Wed, 30 Nov 2011 08:47:51 +0200
In-Reply-To: <4ED5BD76.7020204@qca.qualcomm.com> (Mohammed Shafi Shajakhan's
	message of "Wed, 30 Nov 2011 10:51:58 +0530")
Message-ID: <8739d6gl7s.fsf@purkki.adurom.net> (sfid-20111130_074759_486749_AB95FB93)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com> writes:

> unassociated state for station.
>
> but I observed this when i tested ad-hoc mode. I just started an
> ad-hoc mode creator and left it for some time with no one joining. i
> observed there are few frames in rx_tasklet of ath9k driver which seem
> to be beacons and their BSSID is '0', as our curbssid is also '0' they
> seem to be wrongly identified as 'my_beacons'.

This is a perfect addition to the commit log. Remember that the commit
log should especially answer the question "why?".

-- 
Kalle Valo
