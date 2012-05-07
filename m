Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39327 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab2EGLmC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 07:42:02 -0400
Message-ID: <1336390921.4325.19.camel@jlt3.sipsolutions.net> (sfid-20120507_134209_117801_7A38BBE1)
Subject: Re: [RFCv2 4/6] mac80211: softamp: Handle assoc request
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
Cc: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Mon, 07 May 2012 13:42:01 +0200
In-Reply-To: <1335273460-12682-5-git-send-email-Andrei.Emeltchenko.news@gmail.com> (sfid-20120424_151656_805125_63BCA33F)
References: <1335273460-12682-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	 <1335273460-12682-5-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	 (sfid-20120424_151656_805125_63BCA33F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-24 at 16:17 +0300, Andrei Emeltchenko wrote:
> From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
> 
> Handle AMP assoc request.

This needs knowledge about channel preferences etc. I think it should be
done in wpa_supplicant.

johannes

