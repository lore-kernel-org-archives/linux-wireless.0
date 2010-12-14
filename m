Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:35834 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756477Ab0LNTFH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 14:05:07 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PSaBN-0006BF-1j
	for linux-wireless@vger.kernel.org; Tue, 14 Dec 2010 20:05:05 +0100
Received: from i5E86C328.versanet.de ([94.134.195.40])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 20:05:05 +0100
Received: from stecklum by i5E86C328.versanet.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 20:05:05 +0100
To: linux-wireless@vger.kernel.org
From: Bringfried Stecklum <stecklum@tls-tautenburg.de>
Subject: Re: unresolved symbols due to missing iwlcore.ko
Date: Tue, 14 Dec 2010 19:01:43 +0000 (UTC)
Message-ID: <loom.20101214T195434-788@post.gmane.org>
References: <4D07434F.6070006@tls-tautenburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Turns out that the error is due to a fault of the configuration script. If I
_don't_ select the iwlwifi driver via driver_select and build all drivers
instead, iwlcore.ko will be build as well and properly installed. 

