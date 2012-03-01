Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40547 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab2CAHjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 02:39:07 -0500
Subject: Re: [PATCH 1/2] mac80211_hwsim:  Add tsf to beacons and radiotap
 header.
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
In-Reply-To: <1330561776-8135-1-git-send-email-javier@cozybit.com> (sfid-20120301_013021_099744_8E096896)
References: <1330561776-8135-1-git-send-email-javier@cozybit.com>
	 (sfid-20120301_013021_099744_8E096896)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Mar 2012 08:38:59 +0100
Message-ID: <1330587539.3623.0.camel@jlt3.sipsolutions.net> (sfid-20120301_083911_719033_D107D592)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-02-29 at 16:29 -0800, Javier Cardona wrote:
> Generate a tsf from jiffies.  Prepare the path for having different tsf
> offsets on the each phy.  This will be useful for testing mesh
> synchronization algorithms.

I think you should also add it to probe responses.

johannes

