Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52956 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757535AbbGQNoP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 09:44:15 -0400
Message-ID: <1437140653.1933.22.camel@sipsolutions.net> (sfid-20150717_154418_512925_F18E20F5)
Subject: Re: [PATCH 07/10] mac80211: add possibility to advertise 802.11 FTM
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>
Date: Fri, 17 Jul 2015 15:44:13 +0200
In-Reply-To: <1436359312-26533-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150708_144228_968070_E0A49984)
References: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1436359312-26533-8-git-send-email-emmanuel.grumbach@intel.com>
	 (sfid-20150708_144228_968070_E0A49984)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-07-08 at 15:41 +0300, Emmanuel Grumbach wrote:
> From: Gregory Greenman <gregory.greenman@intel.com>
> 
> Add possibility for a driver to advertise 802.11 Fine Timing 
> Measurement support.
> 
I believe that without any API whatsoever, the device won't be able to
know what to do even if everything is supported in firmware? I'll not
apply this for now.

johannes
