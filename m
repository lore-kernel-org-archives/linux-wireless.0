Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47784 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2ITHeL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 03:34:11 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TEbGz-0006xs-VQ
	for linux-wireless@vger.kernel.org; Thu, 20 Sep 2012 09:34:10 +0200
Message-ID: <1348126488.4161.11.camel@jlt4.sipsolutions.net> (sfid-20120920_093414_877446_F3F86262)
Subject: Re: [PATCH] cfg80211: constify name parameter to add_virtual_intf
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 20 Sep 2012 09:34:48 +0200
In-Reply-To: <1348039998-7739-1-git-send-email-johannes@sipsolutions.net> (sfid-20120919_093247_434548_B47DB518)
References: <1348039998-7739-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120919_093247_434548_B47DB518)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-09-19 at 09:33 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The name can't be modified by the driver,
> make it const.

Applied.

johannes

