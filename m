Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54848 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3HANIW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 09:08:22 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1V4sc9-0002j0-2a
	for linux-wireless@vger.kernel.org; Thu, 01 Aug 2013 15:08:21 +0200
Message-ID: <1375362498.8608.15.camel@jlt4.sipsolutions.net> (sfid-20130801_150824_141007_A0EEDF64)
Subject: Re: [PATCH] mac80211: add debugfs for driver-buffered TID bitmap
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 01 Aug 2013 15:08:18 +0200
In-Reply-To: <1374496504-17705-1-git-send-email-johannes@sipsolutions.net> (sfid-20130722_143513_854987_E9A417DF)
References: <1374496504-17705-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130722_143513_854987_E9A417DF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-07-22 at 14:35 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Add a per-station debugfs file indicating the TIDs (as
> a bitmap) that the driver has data buffered on.

Applied.

johannes

