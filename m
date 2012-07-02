Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:62522 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab2GBXKx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 19:10:53 -0400
Received: by ghrr11 with SMTP id r11so4683710ghr.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jul 2012 16:10:52 -0700 (PDT)
MIME-Version: 1.0
From: Amith Belur <amithbn@gmail.com>
Date: Tue, 3 Jul 2012 01:10:32 +0200
Message-ID: <CADxMoMdusT7bvjBhh3fuT_0G2qEJko-P2LEugZjWvEQLE1tx-Q@mail.gmail.com> (sfid-20120703_011056_772135_7BCB9F52)
Subject: Stations processing probe requests from other stations
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everyone,

I need to modify station behavior such that it looks for certain IEs
in probe requests from other stations associated with every BSS. I
tried looking into rx.c under mac80211. However, I am not quite clear
of where I need to change the code so that management frames of kind
probe requests are not dropped and that I can read some fields from
it. Any help will be appreciated!

Thanks

--
Best Regards,
Amith
