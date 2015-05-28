Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57078 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbbE1Mgy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 08:36:54 -0400
Message-ID: <1432816609.2459.3.camel@sipsolutions.net> (sfid-20150528_143657_567709_354FBA9A)
Subject: Re: [PATCH] mac80211: fix kernel-doc comments in mac80211.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: andrey.konovalov@linaro.org, emmanuel.grumbach@intel.com,
	linux-wireless@vger.kernel.org
Date: Thu, 28 May 2015 14:36:49 +0200
In-Reply-To: <1432816470.6319.41.camel@decadent.org.uk>
References: <555a4e12.e323700a.26a6.ffff9e65@mx.google.com>
	 (sfid-20150518_223947_537367_CC6BC263) <1432127031.19214.9.camel@sipsolutions.net>
	 <1432769411.6319.36.camel@decadent.org.uk>
	 <1432796432.2459.0.camel@sipsolutions.net>
	 <1432816470.6319.41.camel@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-05-28 at 13:34 +0100, Ben Hutchings wrote:

> It's a build failure so it should go upstream now.

Ok, I was under the impression it's a warning.

I guess I'll just have to send a copy of the commit to 4.1 then - git
will sort out getting it twice I suppose.

johannes

