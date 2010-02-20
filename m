Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:64373 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab0BTSbo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Feb 2010 13:31:44 -0500
Received: by wwf26 with SMTP id 26so158024wwf.19
        for <linux-wireless@vger.kernel.org>; Sat, 20 Feb 2010 10:31:43 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Frederic Leroy <fredo@starox.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: rtl8192su: fix compile error from wireless-testing commit
References: <20100218002526.01d1de5f@houba>
	<20100219195215.GL4950@tuxdriver.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 20 Feb 2010 20:31:40 +0200
In-Reply-To: <20100219195215.GL4950@tuxdriver.com> (John W. Linville's message of "Fri\, 19 Feb 2010 14\:52\:16 -0500")
Message-ID: <871vgfhi7n.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> Since I've got the 'offending' commit in my tree, I'll carry this
> staging fixup as well...

And I was the one who broke this, sorry. What's the general rule for
this, should I also start compile testing staging drivers when
changing something?

-- 
Kalle Valo
