Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61442 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab0JEXdk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 19:33:40 -0400
Received: by iwn5 with SMTP id 5so8926435iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Oct 2010 16:33:40 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 5 Oct 2010 19:33:40 -0400
Message-ID: <AANLkTin9hFUE_RH0Zb4OuV2dU_kJs6_ap=VxEmT3e3F8@mail.gmail.com>
Subject: Why were patches reverted on 2010-09-21? (carl9170 and others)
From: Christian Jaeger <chrjae@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello John W. Linville & list,

I wonder why on 2010-09-21 you reverted a bunch of patches by
Christian Lamparter, along with others:

git log d1222bce4344bdbfd1443c310c56a2fa7326ab85..8440f453633abac1503734fb3054b5686c5ac5ae^

I want to try the carl9170 driver, and so I've done a regex search for
carl9170 in wireless-testing/master, and cherry-picked them on top of
the current stable kernel (v2.6.35.7). When double checking I noticed
these reverts, which left me wondering whether that was an unnoticed
mistake and I should actually keep all of Christian Lamparter's
patches. The revert commits don't carry any explanation and I haven't
found it mentioned in the list archive.

(The patches applied cleanly, but I haven't built or tested the kernel
yet; to avoid forgetting to send this notice, I'm sending it away
already.)

Thanks
Christian.
