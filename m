Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:8559 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbaKLNJR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 08:09:17 -0500
Message-ID: <1415797732.3814.17.camel@linux.intel.com> (sfid-20141112_140931_322289_A7C5786C)
Subject: Re: [PATCH 1/2] mac80211-hwsim: Factor out netlink attribute
 appending
From: Patrik Flykt <Patrik.Flykt@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 12 Nov 2014 15:08:52 +0200
In-Reply-To: <1415611968.1847.7.camel@sipsolutions.net>
References: <1415348520-28558-1-git-send-email-patrik.flykt@linux.intel.com>
	 <1415348520-28558-2-git-send-email-patrik.flykt@linux.intel.com>
	 (sfid-20141107_092208_883031_E35223C8) <1415611968.1847.7.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-11-10 at 10:32 +0100, Johannes Berg wrote:
> You seem to have lost the nlmsg_free() in error cases.

Indeed. Will fix.

	Patrik

