Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50755 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab2JYLym (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 07:54:42 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TRM1J-000373-NP
	for linux-wireless@vger.kernel.org; Thu, 25 Oct 2012 13:54:42 +0200
Message-ID: <1351166118.10421.6.camel@jlt4.sipsolutions.net> (sfid-20121025_135446_119914_1CBBC4E2)
Subject: Re: [PATCH] mac80211: complete bss_info tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 25 Oct 2012 13:55:18 +0200
In-Reply-To: <1351072133-8511-1-git-send-email-johannes@sipsolutions.net> (sfid-20121024_114833_033667_634C092F)
References: <1351072133-8511-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121024_114833_033667_634C092F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-24 at 11:48 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Some fields have been added but were missed in
> tracing, add them now.

Applied.

johannes

