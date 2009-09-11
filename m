Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:48898 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbZIKBuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 21:50:46 -0400
Received: by iwn8 with SMTP id 8so298576iwn.4
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2009 18:50:49 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 10 Sep 2009 18:50:29 -0700
Message-ID: <43e72e890909101850i4ceecd77j6e43668cdbd4aa25@mail.gmail.com>
Subject: Testing of pending patches for ath, ath5k, ath9k, ar9170
To: linux-wireless <linux-wireless@vger.kernel.org>,
	devel@linuxdriverproject.org, ath9k-devel@lists.ath9k.org,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've posted my series of patches so far as PATCH form as I feel
confident about them, but it always helps to get early testers. If you
have ath5k, ath9k, or ar9170 hardware please give these a whirl on top
of wireless-testing. Nothing much has changed except a lot of code
shuffling and the start of hw code sharing. I'm curious if any user on
real single CPU boxen notices any differences, I would doubt it, but
hey, lets see.

http://bombadil.infradead.org/~mcgrof/patches/ath/2009/09/all-2009-09-10.patch

After this I guess there's just a few tiny places to address on hw
related code to ensure ath_softc is not used, once this is all cleaned
up we can start using the code as-is on ath9k_htc.

  Luis
