Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52471 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab2LFNC5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 08:02:57 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Tgb6N-0002yq-UK
	for linux-wireless@vger.kernel.org; Thu, 06 Dec 2012 14:02:56 +0100
Message-ID: <1354799000.10150.3.camel@jlt4.sipsolutions.net> (sfid-20121206_140259_949523_28B32B70)
Subject: Re: [PATCH] wireless: fix VHT max AMPDU exponent definition
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 06 Dec 2012 14:03:20 +0100
In-Reply-To: <1354722331-24251-1-git-send-email-johannes@sipsolutions.net> (sfid-20121205_164513_483000_C29DB818)
References: <1354722331-24251-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121205_164513_483000_C29DB818)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-05 at 16:45 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This is really a 3-bit field, not a single bit,
> so declare a mask and shift. Also fix hwsim, it
> advertises the maximum possible.
> 
> While at it reindent all the defines using tabs
> instead of spaces.

Applied.

johannes

