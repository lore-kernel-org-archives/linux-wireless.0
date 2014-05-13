Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38448 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932931AbaEMNIA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 09:08:00 -0400
Message-ID: <1399986467.4137.15.camel@jlt4.sipsolutions.net> (sfid-20140513_150826_502573_120C00ED)
Subject: Re: [PATCH] mac80211: add TX frame consecutive loss statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Matti Gottlieb <matti.gottlieb@intel.com>
Date: Tue, 13 May 2014 15:07:47 +0200
In-Reply-To: <1399798043-20891-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1399798043-20891-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-05-11 at 11:47 +0300, Emmanuel Grumbach wrote:
> From: Matti Gottlieb <matti.gottlieb@intel.com>
> 
> Measure TX frames consecutive loss statistics per station/TID.
> These Measurements are disabled by default and can be enabled
> via debugfs.

I'm guessing that we're the only user of this, and we're evaluating
moving to tracing. As such, I'm not going to apply this and hope that
we'll be able to use tracing (with some added tracepoints) instead -
maybe even removing the other code that we already have here.

johannes

