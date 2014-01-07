Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47176 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbaAGP0D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 10:26:03 -0500
Message-ID: <1389108360.4645.6.camel@jlt4.sipsolutions.net> (sfid-20140107_162610_470376_AF825C30)
Subject: Re: [PATCH] mac80211: allow to set smps mode to OFF in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 07 Jan 2014 16:26:00 +0100
In-Reply-To: <1389093101-12186-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1389093101-12186-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-07 at 13:11 +0200, Emmanuel Grumbach wrote:
> In managed mode, we should not ask for OFF mode because the
> power settings may still require DYNAMIC. In AP mode, this
> should be allowed since the default settings is OFF and
> AUTOMATIC is not allowed.

Applied.

johannes

