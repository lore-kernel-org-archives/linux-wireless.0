Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34427 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab2FRTVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 15:21:53 -0400
Received: by wgbdr13 with SMTP id dr13so5971243wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 12:21:52 -0700 (PDT)
Message-ID: <4FDF7FCD.8010504@gmail.com> (sfid-20120618_212158_277031_8E5E108A)
Date: Mon, 18 Jun 2012 21:21:49 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: mcgrof@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: ath: mising regDomain(EEPROM)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

regulatory domain definitions missing, taken from FreeBSD:

	ETSI8_WORLD	= 0x3D,		/* Russia */
	ETSI9_WORLD	= 0x3E,		/* Ukraine */
	APL2_FCCA	= 0x4D,		/* Mobile customer */
	APL10_WORLD	= 0x5F,		/* Korea 5GHz; After 11/2007; STAs only */
	NULL1		= 0x0198,	<- What's that ????????

can anyone from qualcomm check this?
