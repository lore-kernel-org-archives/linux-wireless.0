Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hyde.gogi.tv ([87.106.167.24]:40731 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755476Ab0HEOOZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 10:14:25 -0400
Received: from pippo.localnet (p5B176F11.dip.t-dialin.net [91.23.111.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by hyde.gogi.tv (Postfix) with ESMTPSA id 3A0844800B
	for <linux-wireless@vger.kernel.org>; Thu,  5 Aug 2010 14:14:23 +0000 (UTC)
From: Daniel Haid <d.haid@gogi.tv>
To: linux-wireless@vger.kernel.org
Subject: Capturing packets with bad FCS in monitor mode
Date: Thu, 5 Aug 2010 16:14:11 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201008051614.11546.d.haid@gogi.tv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

is it possible to receive packets with bad FCS in monitor mode (ath9k driver)?
There is a comment in ath9k/common.c which says that a bad checksum is
ignored in monitor mode, but I have so far never been able to receive a
packet with bad FCS (I do not know how to generate such packets,
so I might just be too lucky that all packets are received unimpaired).

Does ath9k hardware drop packets with bad FCS directly? If so, can
it be disabled?

Best regards.
