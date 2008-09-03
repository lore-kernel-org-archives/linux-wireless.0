Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:45664 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbYICC76 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 22:59:58 -0400
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: at76_usb.[ch] gone fishing from wireless-testing ?
References: <43e72e890809021953o29c6ba53wcdf7630d4ff10b30@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 03 Sep 2008 05:59:27 +0300
In-Reply-To: <43e72e890809021953o29c6ba53wcdf7630d4ff10b30@mail.gmail.com> (ext Luis R. Rodriguez's message of "Tue\, 2 Sep 2008 19\:53\:41 -0700")
Message-ID: <87vdxedje8.fsf@nokia.com> (sfid-20080903_050002_311049_6C2DB6D0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@gmail.com> writes:

> A few times now I've git-fetch'd origin and noticed at76_usb.[ch]
> missing on origin/master. Strange, wondering if you're aware of any
> such type of issues or its just me.

Good point, I don't see it either. But at76_usb is quite broken
currently, so maybe John decided just to drop it? Good choice, at
least for now.

And it's not just that, also -wl suffix is missing from the version.

My HEAD is currently:

commit 18c8adeb0244f823ba78a51e23f813fe68bc3c54
Author: Michael Buesch <mb@bu3sch.de>
Date:   Thu Aug 28 19:33:40 2008 +0200

    b43: Rewrite TX power adjustment

-- 
Kalle Valo
