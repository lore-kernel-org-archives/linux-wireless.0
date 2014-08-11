Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56376 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbaHKO77 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 10:59:59 -0400
Message-ID: <1407769195.9844.1.camel@jlt4.sipsolutions.net> (sfid-20140811_170002_815385_5500A326)
Subject: Re: [PATCH] ieee80211: Support parsing TPC report element in action
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Mon, 11 Aug 2014 16:59:55 +0200
In-Reply-To: <1406720178-6178-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1406720178-6178-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-07-30 at 14:36 +0300, Emmanuel Grumbach wrote:
> From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> 
> TPC report element is contained in spectrum management's tpc report
> action frames and in radio measurement's link measurement report
> action frames. Add a function which checks whether an action frame
> contains this element. This may be needed by the drivers in order
> to set the correct tx power value in these frames.

Applied.

johannes

