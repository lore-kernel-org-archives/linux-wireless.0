Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:45869 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964792Ab3GCTGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 15:06:19 -0400
Received: by mail-la0-f44.google.com with SMTP id er20so484715lab.3
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 12:06:18 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 3 Jul 2013 12:05:57 -0700
Message-ID: <CAB=NE6X0vJ4Ts6p8M3i9GyZPCY6Gf6ztCdWvhdsVySO+4CL7pg@mail.gmail.com> (sfid-20130703_210626_593549_D6D18048)
Subject: IEEE VHT80 802.11 channels
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Felix Bitterli <ic.felix@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We reviewed a while ago how we'd enable VHT80 channels and decided to
go with a scaping of the regulatory data even though IEEE defined very
specific channels. I hadn't seen a list with these center of freq IEEE
channels so I figured I'd post them. As far as I can tell I see these
defined. Whether or not you can use them will vary depending on your
country's regulatory rules.

5210, 5290, 5530, 5610, 5610, 5690, 5775

  Luis
