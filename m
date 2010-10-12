Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:36226 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758127Ab0JLUV0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 16:21:26 -0400
Received: from [10.162.252.213] (essapo-nirac252213.europe.nokia.com [10.162.252.213])
	by mgw-sa01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id o9CKLNjZ016124
	for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 23:21:23 +0300
Subject: wl12xx/master branch has been reset
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 23:21:22 +0300
Message-ID: <1286914882.1551.18.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have reset the wl12xx/master branch, because there were lots of merge
conflicts to resolve and I reckoned it was not worth the trouble.

Sorry for the trouble this causes, but if you had anything on top of
this tree before I reset it, you'll have to rebase.

I'll always try to avoid this as much as possible, but in some cases it
will be necessary.

The other branches, wireless-next (which is the one feeding John's tree)
and wl12xx-next, which is the "stable" wl12xx branch, have not been
changed and are still linear.

And, in case you're wondering, the wireless-testing branch is only used
eventually, to push things to John's wireless-testing tree.  You
shouldn't care about that one.

-- 
Cheers,
Luca.

