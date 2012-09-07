Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52059 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2IGISk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 04:18:40 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1T9tlv-0004wC-L9
	for linux-wireless@vger.kernel.org; Fri, 07 Sep 2012 10:18:39 +0200
Message-ID: <1347005958.4256.3.camel@jlt4.sipsolutions.net> (sfid-20120907_101843_780581_E1DB2F2B)
Subject: Re: [PATCH] mac80211_hwsim: move module_init/exit
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 07 Sep 2012 10:19:18 +0200
In-Reply-To: <1346944197-13140-1-git-send-email-johannes@sipsolutions.net> (sfid-20120906_170924_292556_5DAAC6EF)
References: <1346944197-13140-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120906_170924_292556_5DAAC6EF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-06 at 17:09 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> These should be with the functions so move
> the module_init/exit statements.

Applied.


