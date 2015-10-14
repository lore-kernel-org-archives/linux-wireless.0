Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:33960 "EHLO
	mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbbJNVjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 17:39:04 -0400
Received: by qkfm62 with SMTP id m62so26991030qkf.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 14:39:03 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 14 Oct 2015 17:39:02 -0400
Message-ID: <CAP-AUyiL3R6+tERkg5pm0oRWv=Hwctu8ZCa=cbi_9uhVpazFvQ@mail.gmail.com> (sfid-20151014_233908_001221_3978C274)
Subject: MIMO Transmit
From: Brandon Enochs <enochs.brandon@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Does anyone know how to perform raw transmit at an arbitrary MIMO data
rate?  It seems to work great for all the 802.11a/b/g rates by masking
off all but one rate with nl80211, but I can't seem to figure it out
for 802.11n for any HT enabled channel bandwidths.

Any help is greatly appreciated,
Brandon
