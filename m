Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45337 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab3FMI2d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jun 2013 04:28:33 -0400
Message-ID: <1371112106.8335.0.camel@jlt4.sipsolutions.net> (sfid-20130613_102838_036617_DAAFA721)
Subject: Re: [PATCH] mac80211: Ensure tid_start_tx is protected by sta->lock.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Thu, 13 Jun 2013 10:28:26 +0200
In-Reply-To: <1371071324-12440-1-git-send-email-greearb@candelatech.com> (sfid-20130612_231349_459253_446F29CA)
References: <1371071324-12440-1-git-send-email-greearb@candelatech.com>
	 (sfid-20130612_231349_459253_446F29CA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-06-12 at 14:08 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> All accesses of the tid_start_tx lock should be protected
> by sta->lock if there is any chance that another thread
> could still be accessing the sta object.

Applied.

johannes

