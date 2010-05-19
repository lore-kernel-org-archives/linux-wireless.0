Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58302 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758052Ab0ESNAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 09:00:12 -0400
Date: Wed, 19 May 2010 08:59:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 00/20] pending ath5k + antenna patches
Message-ID: <20100519125941.GA2412@tuxdriver.com>
References: <20100519012528.22206.77550.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100519012528.22206.77550.stgit@tt-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 19, 2010 at 10:30:39AM +0900, Bruno Randolf wrote:

> Also i'd like to note that there are quite a few ath5k patches which haven't
> made it into linux-next yet. It would be great to get them into 2.6.35...

That probably won't happen.  The exception would be for self-contained
bug fixes.  As for linux-next, Stephen usually asks not to merge
anything into linux-next feeder trees during the merge window unless
they are intended to go to the current release.  So, non-bugfix patches
probably won't be going to linux-next either for another week or so.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
