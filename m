Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48023 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbaC1Iai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 04:30:38 -0400
Message-ID: <1395995434.4175.1.camel@jlt4.sipsolutions.net> (sfid-20140328_093044_123994_133AA22F)
Subject: Re: [PATCH] mac80211: Disable SMPS for the monitor interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	Ido Yariv <idox.yariv@intel.com>
Date: Fri, 28 Mar 2014 09:30:34 +0100
In-Reply-To: <1395647745-7857-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1395647745-7857-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-24 at 09:55 +0200, Emmanuel Grumbach wrote:
> From: Ido Yariv <ido@wizery.com>
> 
> All antennas should be operational when monitoring to maximize
> reception.

Applied.

johannes

