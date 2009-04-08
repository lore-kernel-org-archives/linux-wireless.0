Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:29168 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbZDHBId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 21:08:33 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 7 Apr 2009 18:08:17 -0700
Message-ID: <43e72e890904071808t20513fa1h524a15a2cd039856@mail.gmail.com> (sfid-20090408_030837_857070_CA6F2CDA)
Subject: [ANN] Stable kernel series Linux wireless backports
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have been letting users get bleeding edge wireless through
compat-wireless [1] since 2.6.22. This has worked great by giving
wireless-testing more exposure and more testing. Sometimes users don't
want to go all out on bleeding edge and sometimes you simply cannot
upgrade your kernel. For those of you we're going to start releasing
backports of Linux wireless for the stable kernel series. What this
means is you will be able to get future stable kernel releases with
the wireless subsystem backported for you and available when you are
on kernels >= 2.6.27.

As an example today 2.6.30-rc1 was released, so you can now download
the 2.6.31-rc1 wireless subsystem alone and install it on a system on
kernels >= 2.6.27.

So here is the first release:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.30/compat-wireless-2.6.30-rc1.tar.bz2

Just as you would test 2.6.30-rc1 if you just want to test the
wireless stuff from that kernel release you can use this. Please let
me know if it compiles on 2.6.27..2.6.29 (I'm already on 2.6.30) but I
think it should.

Users looking for things a little more stable than wireless-testing
can use this. The other added benefit is if you need to support
customers using a newer wireless subsystem than what your customers
have available you won't need to branch of off specific release from
wireless-testing and waste energy and time on backporting fixes to
random wireless-testing snapshots, instead you can rely on the
compat-wireless stable series backports -- any bugs found should be
fixed and merged back upstream.

If I have time I'll see if I can prep one up based on 2.6.29, if not
please feel free to send patches. I figure we shouldn't bother with
2.6.28 and 2.6.27-- that is backporting this stuff as most users
should already be there by now. You can find the specific
compat-wireless changes for each stable kernel on the compat-wireless
branches.

  Luis

[1] http://wireless.kernel.org/en/users/Download
