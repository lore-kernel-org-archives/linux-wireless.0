Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49922 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaBKL64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 06:58:56 -0500
Message-ID: <1392119933.4128.1.camel@jlt4.sipsolutions.net> (sfid-20140211_125858_993336_A7799423)
Subject: Re: [PATCH] mac80211: add beacon_loss debugfs file
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>
Date: Tue, 11 Feb 2014 12:58:53 +0100
In-Reply-To: <1392114978-26697-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1392114978-26697-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-11 at 12:36 +0200, Emmanuel Grumbach wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> Add beacon_loss debugfs file that emulates
> ieee80211_beacon_loss call from the driver.
> 
> This can be used for various testing scenarios.

Applied.

johannes

