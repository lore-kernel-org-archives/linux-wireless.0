Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47998 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1GTL7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 07:59:41 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1QjVRE-0002NS-4j
	for linux-wireless@vger.kernel.org; Wed, 20 Jul 2011 13:59:40 +0200
Subject: Re: [ANN] iw: v3.0
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <E1QjVQ9-0002Ml-3x@sipsolutions.net>
References: <E1QjVQ9-0002Ml-3x@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jul 2011 13:59:37 +0200
Message-ID: <1311163177.3870.4.camel@jlt3.sipsolutions.net> (sfid-20110720_135944_152754_A2169B7A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-20 at 13:58 +0200, wireless@sipsolutions.net wrote:
> A new release of iw (v3.0) is available at:
> 
> http://wireless.kernel.org/download/iw/iw-3.0.tar.bz2

With this version, I'm moving to versioning based on the kernel version.
The iw version will reflect the kernel version that it was based on in
terms of nl80211 API.

johannes

