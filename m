Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42714 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab2HAIpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 04:45:50 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SwUYu-0002sP-9W
	for linux-wireless@vger.kernel.org; Wed, 01 Aug 2012 10:45:48 +0200
Message-ID: <1343810743.4638.0.camel@jlt3.sipsolutions.net> (sfid-20120801_104556_493171_7DD88327)
Subject: Re: [PATCH] mac80211: manage carrier state in mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 01 Aug 2012 10:45:43 +0200
In-Reply-To: <1343670291-7144-1-git-send-email-johannes@sipsolutions.net> (sfid-20120730_194459_424244_459C5C47)
References: <1343670291-7144-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120730_194459_424244_459C5C47)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-30 at 19:44 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Instead of assuming the carrier is on all
> the time in mesh manage it with joining
> and leaving the mesh.

Applied.

johannes

