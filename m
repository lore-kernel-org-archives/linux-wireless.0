Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48467 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473Ab2HFT1T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 15:27:19 -0400
Received: by bkwj10 with SMTP id j10so1170466bkw.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 12:27:18 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] p54: parse output power table
Date: Mon, 6 Aug 2012 21:27:12 +0200
Cc: linux-wireless@vger.kernel.org
References: <E1Suve7-0006U2-4H@debian64.localnet> <20120806190317.GB26210@tuxdriver.com>
In-Reply-To: <20120806190317.GB26210@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201208062127.12933.chunkeey@googlemail.com> (sfid-20120806_212723_288694_E16C175B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, August 06, 2012 09:03:17 PM John W. Linville wrote:
> patching file drivers/net/wireless/p54/eeprom.c
> Hunk #1 succeeded at 77 with fuzz 2 (offset 1 line).
> Hunk #2 succeeded at 175 (offset 1 line).
> Hunk #3 FAILED at 192.
> Hunk #4 succeeded at 233 (offset 2 lines).
> Hunk #5 FAILED at 244.
> Hunk #6 succeeded at 321 (offset 3 lines).
> Hunk #7 succeeded at 847 (offset 3 lines).
hmm, it applies cleanly here.

Do you have another patch in your pipeline?
(If it's the tpc patch that is causing the
rejects, then can you please drop it, as it
depends on the tpc algorithm which isn't
in place yet)

Regards,
	Chr

