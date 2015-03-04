Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:32700 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750890AbbCDXCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 18:02:38 -0500
Message-ID: <20150304230225.J5EHX.13935.root@cdptpa-web27> (sfid-20150305_000244_637611_A762468C)
Date: Wed, 4 Mar 2015 23:02:25 +0000
From: <marco@tampabay.rr.com>
To: linux-wireless@vger.kernel.org
Subject: carl1970: monitor mode only displaying beacons/probs from APs?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

carl1970: monitor mode only displaying beacons/probs from APs

Hello,

Quite a while back after doing an upgrade to the latest (back then)
compat-wireless, I noticed that I was only seeing beacon,prob requests, and
the occasional data packet when in monitor mode; which at the time I wrote
off.  After switching to backports-3.18.1-1 recently, I still see the same
behavior(on x86 and arm).  I'm sure I'm missing something, but I couldn't
find any references to this behavior in my search.  I also tried "iw wlanX
set monitor control otherbss" to no avail.  Switching to a different chipset
using ath9k-htc showed expected traffic.

Can anyone point me in the right direction?

Regards,

Marco Fonseca
