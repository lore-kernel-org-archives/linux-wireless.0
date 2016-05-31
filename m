Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40429 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877AbcEaJq1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 05:46:27 -0400
Message-ID: <1464687984.3076.4.camel@sipsolutions.net> (sfid-20160531_114630_966926_B39F3ABA)
Subject: Re: [PATCH] iw: Fix -Wabsolute-value compiler warning in iw.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Aurimas Liutikas <aurimas@google.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 31 May 2016 11:46:24 +0200
In-Reply-To: <CAFiGRCEyxdcuMf5yn3WU-bhnD5AhQmuP++eXaB1j8jmPkx7yQA@mail.gmail.com> (sfid-20160512_181631_611402_FF868A94)
References: <CAFiGRCEyxdcuMf5yn3WU-bhnD5AhQmuP++eXaB1j8jmPkx7yQA@mail.gmail.com>
	 (sfid-20160512_181631_611402_FF868A94)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Applied.

However, note that I had to do it manually, so if you're planning to
send any more patches please fix your mailer to not corrupt whitespace
(the tabs were replaced by spaces, so the patch couldn't apply
automatically)

johannes

