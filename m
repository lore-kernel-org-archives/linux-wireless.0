Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaDYPoc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 11:44:32 -0400
Message-ID: <1398439905.4152.16.camel@jlt4.sipsolutions.net> (sfid-20140425_174443_737023_F0370674)
Subject: Re: [PATCH 05/12] mac80211: remove unnecessary BUG_ON()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 25 Apr 2014 17:31:45 +0200
In-Reply-To: <fd686aea6dc877a9d6ecbfabba68b4e1e8b645d0.1398055854.git.gamerh2o@gmail.com> (sfid-20140421_065508_270691_2019E1D6)
References: <cover.1398055853.git.gamerh2o@gmail.com>
	 <fd686aea6dc877a9d6ecbfabba68b4e1e8b645d0.1398055854.git.gamerh2o@gmail.com>
	 (sfid-20140421_065508_270691_2019E1D6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-04-21 at 12:53 +0800, Zhao, Gang wrote:
> The BUG_ON(!err) can't be triggered in the code path, so remove
> it.

Applied.

Btw, it was a bit confusing that you sent your older patches in this
patchset again, please avoid that or at least tell me you did that.

johannes

