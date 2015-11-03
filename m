Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55475 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbbKCJnH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 04:43:07 -0500
Message-ID: <1446543784.29010.10.camel@sipsolutions.net> (sfid-20151103_104822_745002_FFBA4327)
Subject: Re: [PATCH 02/10] mac80211: TDLS: add proper HT-oper IE
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Date: Tue, 03 Nov 2015 10:43:04 +0100
In-Reply-To: <1445763582-11421-2-git-send-email-emmanuel.grumbach@intel.com>
References: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1445763582-11421-2-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-10-25 at 10:59 +0200, Emmanuel Grumbach wrote:
> From: Arik Nemtsov <arik@wizery.com>
> 
> When 11n peers performs a TDLS connection on a legacy BSS, the HT
> operation IE must be specified according to IEEE802.11-2012 section
> 9.23.3.2. Otherwise HT-protection is compromised and the medium 
> becomes
> noisy for both the TDLS and the BSS links.
> 
Applied.

johannes
