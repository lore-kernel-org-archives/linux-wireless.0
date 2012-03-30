Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:53926 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab2C3BRh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2012 21:17:37 -0400
Date: Fri, 30 Mar 2012 10:17:34 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: iwlagn (3.3-wl), the saga continuous
Message-ID: <20120330011734.GH6277@gamma.logic.tuwien.ac.at> (sfid-20120330_031757_711616_AB85C74A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I am now running 3.3.0-wl, and I was now travelling quite some time
without having *any*problems with wlan. But as soon as I come
home or to the university the horror starts. Here at home I am 
now, after fresh reboot, no suspend involved, swamped with dmesg
lines:
[ 8206.158741] delba from 00:0a:79:eb:56:10 (initiator) tid 0 reason code 39
[ 8206.158744] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[ 8206.430282] Rx A-MPDU request on tid 0 result 0

So around 4000+ in 2 hours ... I guess you can evaluate how flaky the
connection is ...

As usual, any patches to be tested etc I can do. All of that is easy
to reproduce ;-)

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
NAAS (n.)
The winemaking region of Albania where most of the wine that people
take to bottle-parties comes from.
			--- Douglas Adams, The Meaning of Liff
