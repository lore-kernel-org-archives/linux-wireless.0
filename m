Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:25953 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbYGQFun (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 01:50:43 -0400
To: "Tomas Winkler" <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] mac80211: make listen_interval be limited by low level driver
References: <1216208814-26314-1-git-send-email-tomas.winkler@intel.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Thu, 17 Jul 2008 08:49:54 +0300
In-Reply-To: <1216208814-26314-1-git-send-email-tomas.winkler@intel.com> (ext Tomas Winkler's message of "Wed\, 16 Jul 2008 14\:46\:54 +0300")
Message-ID: <87sku9awl9.fsf@nokia.com> (sfid-20080717_075047_335118_386F7785)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler <tomas.winkler@intel.com> writes:

> This patch makes possible for a driver to specify maximal listen interval
> The possibility for user to configure listen interval is not implemented
> yet, currently the maximum provided by the driver or 1 is used.
> Mac80211 uses config handler to set listen interval for to the driver.

Looks good to me. Thanks for doing this.

-- 
Kalle Valo
