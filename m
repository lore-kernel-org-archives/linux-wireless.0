Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56749 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbbFJGMS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 02:12:18 -0400
Message-ID: <1433916735.1921.2.camel@sipsolutions.net> (sfid-20150610_081230_789627_6883F942)
Subject: Re: [WEXT]: multiple calls for SIOCGIWSTATS return same value
From: Johannes Berg <johannes@sipsolutions.net>
To: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 10 Jun 2015 08:12:15 +0200
In-Reply-To: <20150609202558.208609e7@erg.abdn.ac.uk>
References: <20150606203721.28791bb3@erg.abdn.ac.uk>
	 <1433747886.2106.5.camel@sipsolutions.net>
	 <20150608195853.239a2622@erg.abdn.ac.uk>
	 <1433835188.1892.5.camel@sipsolutions.net>
	 <20150609202558.208609e7@erg.abdn.ac.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-06-09 at 20:25 -0600, Gerrit Renker wrote:

> Many thanks for providing the patch. I just tried it and it fixed both problems
> (access point signal level/quality and signal level reported for BSSes in scan
> result). Not sure if trace results are still needed, but I can do that if needed.

No, I did the tracing myself - it showed strange behaviour that
eventually helped me pinpoint the problem :)

johannes

