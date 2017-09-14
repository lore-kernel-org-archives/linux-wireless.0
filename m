Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.vm.ouaza.com ([212.83.178.2]:37709 "EHLO mail.vm.ouaza.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751323AbdINOjG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 10:39:06 -0400
Date: Thu, 14 Sep 2017 16:31:34 +0200
From: Raphael Hertzog <buxy@kali.org>
To: linux-wireless@vger.kernel.org
Cc: devel@kali.org, Ben Hutchings <ben@decadent.org.uk>
Subject: Kernel developer to work on wifi injection in mainline
Message-ID: <20170914143134.5ybcusoqu74wf6d7@home.ouaza.com> (sfid-20170914_163909_535476_CCD539AE)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Please keep-me in CC and use reply-to all)

Hello everybody,

I'm working for Kali Linux/Offensive Security. Pentesters rely on working
wifi injection to do their work but support of this feature is sub-optimal
in mainline Linux. This is why we carry a patch:
http://git.kali.org/gitweb/?p=packages/linux.git;a=blob;f=debian/patches/features/all/kali-wifi-injection.patch;h=0b872f83f3ca09c967d9c0c520e11cf7d75dfd91;hb=refs/heads/kali/master

This feature also tends to break on various drivers from time to time
as is currently the case with carl9170 and rt2800usb:
https://bugs.kali.org/view.php?id=4220

Thus we are looking for a kernel developer that we could work with on a
contractor basis to:
- make wifi injection work on the current Kali kernel on various drivers
  that we want to support
- upstream as much as possible of changes needed for wifi injection to
  work
- ensure continued support of the feature in new Linux releases

I wonder whether there are non-technical hurdles that would prevent
merging of wifi injection patches. Are there legal challenges to this for
instance?

Cheers,

PS: We track new kernel release out of Debian Testing so we tend to
use all releases for 2 months.
-- 
Raphaël Hertzog ◈ Kali Linux Developer ◈ Debian Developer

Get the Debian Administrator's Handbook:
→ https://debian-handbook.info/get/
