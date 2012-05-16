Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50527 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758667Ab2EPRRt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 13:17:49 -0400
Date: Wed, 16 May 2012 13:06:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/3] iwlwifi updates
Message-ID: <20120516170634.GC3508@tuxdriver.com> (sfid-20120516_191755_746610_3B5ADB07)
References: <1336666148-24471-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1336666148-24471-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 10, 2012 at 06:09:05PM +0200, Johannes Berg wrote:
> John,
> 
> Here are a few more iwlwifi updates. We rename some functions to
> get rid of the "agn" in them which we're using to indicate that
> the function belongs to the current firmware API, and move a
> macro that we'll need in a few more places.
> 
> johannes

I had trouble with this batch as well...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
