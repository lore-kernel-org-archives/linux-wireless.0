Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35239 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbcDFIYJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 04:24:09 -0400
Message-ID: <1459931045.17504.15.camel@sipsolutions.net> (sfid-20160406_102413_741722_3B885FC6)
Subject: Re: [PATCHv3 RESEND 01/11] cfg80211: add start / stop NAN commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Wed, 06 Apr 2016 10:24:05 +0200
In-Reply-To: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  /**
> + * struct cfg80211_nan_conf - nan configuration
> + *
> + * This struct defines nan configuration parameters

I think you should consistently capitalize "NAN" in comments.

> + * @start_nan: Start the NAN interface.
> + * @stop_nan: Stop the NAN interface.

johannes
