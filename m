Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40815 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab1I0Lqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 07:46:35 -0400
Subject: Re: [PATCH 2/5] mac80211: standardize adding supported rates IEs
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
In-Reply-To: <1317034493-5300-3-git-send-email-arik@wizery.com> (sfid-20110926_125512_356894_083653B1)
References: <1317034493-5300-1-git-send-email-arik@wizery.com>
	 <1317034493-5300-3-git-send-email-arik@wizery.com>
	 (sfid-20110926_125512_356894_083653B1)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 13:46:31 +0200
Message-ID: <1317123991.4082.17.camel@jlt3.sipsolutions.net> (sfid-20110927_134639_305226_F7371B44)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-26 at 13:54 +0300, Arik Nemtsov wrote:
> Relocate the mesh implementation of adding the (extended) supported
> rates IE to util.c, anticipating its use by other parts of mac80211.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> Cc: Kalyan C Gaddam <chakkal@iit.edu>

Thanks! :)

> +EXPORT_SYMBOL(ieee80211_add_srates_ie);

> +EXPORT_SYMBOL(ieee80211_add_ext_srates_ie);

You shouldn't export these.

> \ No newline at end of file

And it's a good idea to have "\n" be the last character of the file :)

johannes

