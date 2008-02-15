Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.riseup.net ([204.13.164.18]:54824 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbYBOT4V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 14:56:21 -0500
Date: Fri, 15 Feb 2008 20:56:32 +0100
From: matthias@kaehlcke.net
To: mcgrof@gmail.com, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [patch 0/3] Prism 54: Convert semaphores to mutexes
Message-ID: <20080215195632.GA22741@traven> (sfid-20080215_195626_766152_AC801D44)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prism 54 driver: The semaphores acl->sem, stats_sem and wpa_sem are
used as mutexes, convert them to the muxex API

-- 
Matthias Kaehlcke
Linux System Developer
Barcelona

              We build too many walls and not enough bridges
                             (Isaac Newton)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
