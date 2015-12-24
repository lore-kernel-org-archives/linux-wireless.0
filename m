Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:33404 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090AbbLXHe4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 02:34:56 -0500
Received: by mail-oi0-f44.google.com with SMTP id y66so135212236oig.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 23:34:55 -0800 (PST)
From: Bart Van Assche <bart.vanassche@gmail.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: ath9k driver broken since kernel v4.2
Message-ID: <567BA01B.60806@acm.org> (sfid-20151224_083459_342287_6E4DE6FF)
Date: Thu, 24 Dec 2015 08:34:51 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

The ath9k driver drops more than 90% of all packets with Linux kernel 
v4.4-rc6 on my laptop. This behavior also occurs with kernel v4.2. 
However, with Linux kernel versions v4.1.5 and v3.19.3 the ath9k driver 
works fine on the same laptop. Is this report sufficient for one of the 
ath9k drivers to look further into this or do you perhaps expect me to 
run a bisect ?

Thanks,

Bart.
