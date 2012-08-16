Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47645 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2HPEG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 00:06:26 -0400
Received: by obbuo13 with SMTP id uo13so3090145obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Aug 2012 21:06:25 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 16 Aug 2012 12:06:25 +0800
Message-ID: <CAEFj985Mv12-hXNYt1Ej1SQ2Z+SnqwpVxTUT638mVO=4iGGHZQ@mail.gmail.com> (sfid-20120816_060705_389665_EFBCABE0)
Subject: ath5k: Hardware Management Frame Protection
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, all

Is the management frame protection (IEEE80211_HW_MFP_CAPABLE)
supported by the ath5k hardware?

Secured mesh requires the support of AES CMAC (00-0f-ac:6) cipher for
multicast management frame. However, this cipher only makes available
by the hardware flag IEEE80211_HW_MFP_CAPABLE. Can I simply turn this
on base.c?

Please advice. Thanks

Regards,
Chun-Yeow
