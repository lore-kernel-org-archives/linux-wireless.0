Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57205 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932710AbaJWSm4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 14:42:56 -0400
Message-ID: <1414089771.29820.3.camel@jlt4.sipsolutions.net> (sfid-20141023_204301_225951_B88A3F7A)
Subject: Re: [PATCH] mac80211: Export IE split function
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Thu, 23 Oct 2014 20:42:51 +0200
In-Reply-To: <1413980569-25501-1-git-send-email-egrumbach@gmail.com> (sfid-20141022_142300_987390_250476C0)
References: <1413980569-25501-1-git-send-email-egrumbach@gmail.com>
	 (sfid-20141022_142300_987390_250476C0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-10-22 at 15:22 +0300, Emmanuel Grumbach wrote:
> From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> 
> Export ieee80211_ie_split function, so it can be reused by drivers
> which require to insert additional elements.

Applied.

johannes

