Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:57418 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab0G0D10 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 23:27:26 -0400
Received: by pxi14 with SMTP id 14so301842pxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jul 2010 20:27:26 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 26 Jul 2010 20:27:06 -0700
Message-ID: <AANLkTim-0qoS7o+fcQ6uA18AC_gQSiiDe4Tv_L1FT1Ae@mail.gmail.com>
Subject: Confused - bisecting wireless-testing
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

04:23  * mcgrof is confused, I just did a git bisect -i on
wireless-testing on some patch on Fri Jul 2 00:09:49 2010  and ended
up with a 2.6.34 top level
          Makefile
04:23 < mcgrof> it was git rebase -i ba17bc5e55ba541d2a8765fca53b6883b667ab21
04:23 < mcgrof> eh
04:24 < mcgrof> how am I supposed to bisect wl now
04:24 < mcgrof> the odd thing though is that the top commit is ancient
04:24 < mcgrof> http://paste.pocoo.org/show/242077/
04:24 < mcgrof> but the other ones are OK

I realize we should use wireless-2.6.git to bisect stable but I need
to bisect against recent patches that spans different master- tags
from you, I figured git bisecting wireless-testing would work now that
you are using a different method to move your tree forward but am I
wrong? Should I only bisect between master tags still?

  Luis
