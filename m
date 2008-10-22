Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40366 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbYJVVUy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 17:20:54 -0400
Date: Wed, 22 Oct 2008 17:20:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH 2/3 v3] p54: put broadcast frames into the right queues
Message-ID: <20081022212008.GL15808@tuxdriver.com> (sfid-20081022_232057_156348_0B375A33)
References: <200810170115.38317.chunkeey@web.de> <200810170354.25392.chunkeey@web.de> <1224332511.6324.3.camel@johannes.berg> <200810182318.44880.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200810182318.44880.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 18, 2008 at 11:18:44PM +0200, Christian Lamparter wrote:
> stlc45xx's specs finally brought some light what all the 4 extra queues for.
> now CAB data and managment frames have their own queue.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>

Doesn't apply...

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
