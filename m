Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55444 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbbA3RoN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 12:44:13 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.84)
	(envelope-from <johannes@sipsolutions.net>)
	id 1YHFc4-0007BZ-4X
	for linux-wireless@vger.kernel.org; Fri, 30 Jan 2015 18:44:12 +0100
Message-ID: <1422639851.1919.37.camel@sipsolutions.net> (sfid-20150130_184416_594385_085BA4B1)
Subject: Re: [PATCH] backports: update genl-const patch for nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 30 Jan 2015 18:44:11 +0100
In-Reply-To: <1422639317-21593-1-git-send-email-johannes@sipsolutions.net> (sfid-20150130_183524_349907_92B477EF)
References: <1422639317-21593-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20150130_183524_349907_92B477EF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-30 at 18:35 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The current wireless tree changes the surrounding code to
> use the exported string constants, so adjust the patch to
> make it apply again.

Wrong list, and Arend sent the same patch already anyway... stupid me.

Sorry for the noise.

johannes

