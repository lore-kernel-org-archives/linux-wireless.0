Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46816 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbbFQIuG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:50:06 -0400
Message-ID: <1434531003.1884.13.camel@sipsolutions.net> (sfid-20150617_105011_612477_994B431D)
Subject: Re: [PATCH] mac80211: clear local->in_reconfig on reconfig error
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>
Date: Wed, 17 Jun 2015 10:50:03 +0200
In-Reply-To: <1433956777-23072-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1433956777-23072-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-10 at 20:19 +0300, Emmanuel Grumbach wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> If reconfiguration fails, local->in_reconfig is never
> cleaned, resulting in rx frames being dropped next
> time the device is started.

Applied.

johannes

