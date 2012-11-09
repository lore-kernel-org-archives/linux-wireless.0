Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53897 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab2KIQXW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 11:23:22 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TWrMW-0008Mm-Oj
	for linux-wireless@vger.kernel.org; Fri, 09 Nov 2012 17:23:20 +0100
Message-ID: <1352478237.9238.12.camel@jlt4.sipsolutions.net> (sfid-20121109_172325_156269_2AD7F3E7)
Subject: Re: [PATCH] mac80211: add debugfs file for HW queues
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 09 Nov 2012 17:23:57 +0100
In-Reply-To: <1352385113-21671-1-git-send-email-johannes@sipsolutions.net> (sfid-20121108_153131_760253_7FEDA0BA)
References: <1352385113-21671-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121108_153131_760253_7FEDA0BA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-08 at 15:31 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Add a debugfs file showing which HW queues were
> allocated to a virtual interface, including the
> CAB queue for AP interfaces.

Applied the fixed version.

johannes

