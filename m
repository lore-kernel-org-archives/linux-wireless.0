Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58391 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488AbcEBUso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2016 16:48:44 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.87)
	(envelope-from <johannes@sipsolutions.net>)
	id 1axKll-0004fK-W3
	for linux-wireless@vger.kernel.org; Mon, 02 May 2016 22:48:42 +0200
Message-ID: <1462222120.5898.8.camel@sipsolutions.net> (sfid-20160502_224846_348690_64DFAE08)
Subject: Re: [PATCH] wext: remove a/b/g/n from SIOCGIWNAME
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 02 May 2016 22:48:40 +0200
In-Reply-To: <1461656142-29456-1-git-send-email-johannes@sipsolutions.net> (sfid-20160426_093549_956386_56939AA0)
References: <1461656142-29456-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20160426_093549_956386_56939AA0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-04-26 at 09:35 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Since a/b/g/n no longer exist as spec amendements and VHT (ex
> 802.11ac)
> wasn't handled at all, it's better to just remove the amendment
> strings
> to avoid confusion.
> 
Applied.

johannes
