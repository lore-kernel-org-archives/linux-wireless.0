Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36025 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933604AbcDFIwU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 04:52:20 -0400
Message-ID: <1459932736.17504.40.camel@sipsolutions.net> (sfid-20160406_105224_142994_640492DB)
Subject: Re: [PATCHv3 RESEND 06/11] cfg80211: Provide an API to report NAN
 function termination
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Wed, 06 Apr 2016 10:52:16 +0200
In-Reply-To: <1459244109-16038-6-git-send-email-emmanuel.grumbach@intel.com>
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1459244109-16038-6-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-03-29 at 12:35 +0300, Emmanuel Grumbach wrote:
> 
> @@ -2246,6 +2248,7 @@ enum nl80211_attrs {
>  	NL80211_ATTR_NAN_FUNC,
>  	NL80211_ATTR_NAN_FUNC_INST_ID,
>  	NL80211_ATTR_NAN_MATCH,
> +	NL80211_ATTR_NAN_FUNC_TERM_REASON,

You can add this as a nested function attribute. If we remove the
FUNC_INST_ID attribute we have to do the nesting anyway.

johannes
