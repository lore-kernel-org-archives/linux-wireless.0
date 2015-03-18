Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:33250 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbbCRO7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 10:59:22 -0400
Received: by ladw1 with SMTP id w1so38297304lad.0
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2015 07:59:20 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 18 Mar 2015 15:59:20 +0100
Message-ID: <CAOFH_kHg8xLMaoAr-1k2cZqmXzZUS=5KRE6Sz2VcD2j4FPT6kA@mail.gmail.com> (sfid-20150318_155925_467234_C7761209)
Subject: ath9k TX99 support on 3.10 kernel
From: Mathieu Slabbinck <matty.slabbinck@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm using a i.mx6 platform with Freescale's linux (3.10.53) from
git.freescale.com/imx/linux-2.6-imx.git.
Since this kernel doesn't have TX99 support, I've looked up the
changes to enable this and started porting patches. Which seemed fine.
All changes listed here
(https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/log/drivers/net/wireless/ath/ath9k?qt=grep&q=tx99)
I've ported to my kernel.

But the /sys/kernel/debug folder remains empty. Where I think I should
get entries to control TX99, correct?

Any ideas?

Kr

Mathieu
