Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:45554 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbZFWT6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 15:58:15 -0400
Received: by bwz9 with SMTP id 9so314797bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jun 2009 12:58:17 -0700 (PDT)
Date: Tue, 23 Jun 2009 19:46:16 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: kernel crashes, 2.6.30, rt2x00, ath5k, ieee80211_get_*_rate,
	automatic rate control
Message-ID: <20090623174616.GA3914@linux-m68k.org>
References: <20090621134954.GA31505@linux-m68k.org> <20090621180447.GA29469@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20090621180447.GA29469@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Got the confirmation that the patch for minstrel indeed does something good to me,
both on the ath5k and rt73usb side. The code path seems to be trigered only in 
special circumstances in my configuration but the printk did fire on both ends
after a while.

Richard

