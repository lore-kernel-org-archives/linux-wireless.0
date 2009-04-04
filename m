Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:62609 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbZDDEP0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Apr 2009 00:15:26 -0400
Received: by wf-out-1314.google.com with SMTP id 29so1489119wff.4
        for <linux-wireless@vger.kernel.org>; Fri, 03 Apr 2009 21:15:24 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 3 Apr 2009 21:15:09 -0700
Message-ID: <43e72e890904032115m7548f967m5020481c660c8f13@mail.gmail.com> (sfid-20090404_061538_305275_FE6AA63E)
Subject: zd1211 3.0.0.56 "vendor driver" - please help port to zd1211rw
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is our latest "vendor driver" for the old zd1211. We much prefer
the in-kernel zd1211rw driver but I've heard a few users with issues
with some devices. Perhaps this might help a few developers help port
over any changes. I myself have not looked at this yet.

http://www.kernel.org/pub/linux/kernel/people/mcgrof/zd1211/LinuxUSB_AR2524-3.0.0.56.tgz

  Luis
