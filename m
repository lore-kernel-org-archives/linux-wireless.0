Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38056 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab2KGDT4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 22:19:56 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so1198593oag.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Nov 2012 19:19:55 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 7 Nov 2012 11:19:55 +0800
Message-ID: <CAEFj985t24UG+PcNjZYeqmadQMxx3gFMLYUgJ1iBtYrmmXZvAQ@mail.gmail.com> (sfid-20121107_042029_138428_67B32482)
Subject: Re: linux 802.11s mesh should process GANN IE for interoperability
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Lin

> Linux mac80211 chooses to ride on RANN, which is fine.
FYI, the Gate Announcement field is also set in the Proactive PREQ.

> But, on receiving side, it should process GANN IE because other vendor may choose to use GANN way.
Yes, I think that it is good to have this process as well.

----
Chun-Yeow
