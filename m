Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:64902 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbaCBBEJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 20:04:09 -0500
Received: by mail-lb0-f180.google.com with SMTP id 10so3739063lbg.11
        for <linux-wireless@vger.kernel.org>; Sat, 01 Mar 2014 17:04:07 -0800 (PST)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Sat, 1 Mar 2014 17:03:47 -0800
Message-ID: <CAB=NE6XVMfCbkb4pu-1qcNbiS3dNrR9LcHWWeLU4M5vm_frE5g@mail.gmail.com> (sfid-20140302_020413_971615_857D68C3)
Subject: Clarification on license for CRDA and wireless-regdb
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Its come to my attention that some silly companies that are afraid to
contribute to advanced copyleft licenses are afraid to make
contributions to wireless-regdb. I'd like to take the time to clarify
that CRDA is under copyleft-next while wireless-regdb is under the ISC
license. wireless-regdb is the project that has the db.txt file which
is used by John to build the regulatory.bin file to the community. In
the event that you build the Linux kernel with db.txt built in you are
using the wireless-regdb file which is under ISC license.

Hope this helps clarify some things for some folks. If there are any
questions please let me know. I abide by the Harvey Birdman Rule [0]
so I appreciate any further questions or discussions to be directed
publicly through these mailing lists.

[0] https://gitorious.org/copyleft-next/copyleft-next/source/3baab310f662811ba48d8a86bfe7f9ef7ef612dc:CONTRIBUTING.md

Thanks,

  Luis
