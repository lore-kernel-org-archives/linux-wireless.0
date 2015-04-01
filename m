Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58259 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbbDAMjF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 08:39:05 -0400
Message-ID: <1427891939.3428.5.camel@sipsolutions.net> (sfid-20150401_143908_199348_078CACB4)
Subject: Re: [PATCH] mac80211: reduce log spam from
 ieee80211_handle_pwr_constr
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 01 Apr 2015 14:38:59 +0200
In-Reply-To: <1427813354-7983-1-git-send-email-linville@tuxdriver.com>
References: <1427813354-7983-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-31 at 10:49 -0400, John W. Linville wrote:
> This changes a couple of messages from sdata_info to sdata_dbg.
> This should reduce some log spam, as reported here:
> 
> 	https://bugzilla.redhat.com/show_bug.cgi?id=1206468
> 
Applied, thanks.

johannes

