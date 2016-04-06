Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35327 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbcDFI1P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 04:27:15 -0400
Message-ID: <1459931231.17504.18.camel@sipsolutions.net> (sfid-20160406_102720_198267_AF645424)
Subject: Re: [PATCHv3 RESEND 02/11] mac80211: add boilerplate code for start
 / stop NAN
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Wed, 06 Apr 2016 10:27:11 +0200
In-Reply-To: <1459244109-16038-2-git-send-email-emmanuel.grumbach@intel.com>
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1459244109-16038-2-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-03-29 at 12:35 +0300, Emmanuel Grumbach wrote:
> This codes doens't do much besides allowing to start and
> stop the vif.

Few typos? :)

> + * @start_nan: join an existing nan cluster, or create a new one.
> + * @stop_nan: leave the nan cluster.

NAN

johannes
