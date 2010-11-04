Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:53687 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab0KDNKG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 09:10:06 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PDzZs-0003yO-OB
	for linux-wireless@vger.kernel.org; Thu, 04 Nov 2010 14:10:04 +0100
Received: from 195.13.137.167 ([195.13.137.167])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 14:10:04 +0100
Received: from Vadims.Kurmis by 195.13.137.167 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 14:10:04 +0100
To: linux-wireless@vger.kernel.org
From: Vadim <Vadims.Kurmis@gmail.com>
Subject: Adding custom channels to ath5k for researching purposes
Date: Thu, 4 Nov 2010 13:03:27 +0000 (UTC)
Message-ID: <loom.20101104T140201-178@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all! I have some problems using ath5k driver with Atheros (AR5414)
DCMA-86P2 mini-PCI modules.
I am developing DSRC/WAVE system for car to car communication based on 802.11p
standard.
DCMA-86P2 modules are designed to operate at 5GHz dedicated band (5,86-5,92GHz)

The first problem is that Linux shows that hardware works in 802.11a mode.
And "iw list"' shows only 802.11a allowed channels at frequencies: 5180-5825MHz.

By following Linux-wireless manual I installed latest kernel, kernel headers,
wireless-tools, iw, CRDA and verified that ath5k module is running.

I need to enable 802.11p standard frequencies. How can I accomplish this? I
found that CRDA is responsible for allowed channels. So, where can I get binary
frequency/channel database to use my hardware for researching purposes ? Is
there an alternative method to enable 802.11p frequencies by modifying ath5k
driver ?

