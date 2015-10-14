Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34434 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbbJNUwH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 16:52:07 -0400
Message-ID: <1444855924.3054.9.camel@sipsolutions.net> (sfid-20151014_225211_436416_85634BE8)
Subject: new regdb file format
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 14 Oct 2015 22:52:04 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I spent a bit of time thinking about a file format that would be more
extensible, yet still be loadable into the kernel without having to
parse it into new data structures in the kernel, i.e. be easy enough to
read when needed.

My considerations
 * must be extensible in some way
 * should be relatively dense
 * 

johannes
