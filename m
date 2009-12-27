Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:33664 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbZL0Idk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Dec 2009 03:33:40 -0500
Received: by ewy19 with SMTP id 19so1051475ewy.21
        for <linux-wireless@vger.kernel.org>; Sun, 27 Dec 2009 00:33:39 -0800 (PST)
To: Dan Carpenter <error27@gmail.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [patch] wl1271_cmd.c:  cleanup char => u8
References: <20091223132319.GC17923@bicker>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 27 Dec 2009 10:33:36 +0200
In-Reply-To: <20091223132319.GC17923@bicker> (Dan Carpenter's message of "Wed\, 23 Dec 2009 15\:23\:19 +0200")
Message-ID: <87ljgoyfxb.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <error27@gmail.com> writes:

> This is just a clean up and doesn't make a functional difference. It
> keeps the lint checkers happy.

Thanks, looks good.

The "wl1271_cmd.c:" prefix is a bit ugly, though. John, if possible,
can you change that to "wl1271:" before you apply the patch, please?

> Signed-off-by: Dan Carpenter <error27@gmail.com>

Luciano is on vacation right now (the lucky ba^H^Hguy), so I'll act as
a backup:

Reviewed-by: Kalle Valo <kalle.valo@nokia.com>

-- 
Kalle Valo
