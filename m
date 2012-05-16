Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50526 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514Ab2EPRRt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 13:17:49 -0400
Date: Wed, 16 May 2012 13:06:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi updates 2012-05-11
Message-ID: <20120516170657.GD3508@tuxdriver.com> (sfid-20120516_191755_097164_43086E1B)
References: <1336726398-13200-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1336726398-13200-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 11, 2012 at 10:53:14AM +0200, Johannes Berg wrote:
> Here are some more iwlwifi updates :-)
> 
> David Spinadel worked on scanning and got rid of the extra
> wildcard probe. This is at the expense of some probe request
> IE space, but due to the sizing bug that he also fixed the
> IE space was previously actually advertised wrongly, we'd
> already fail at 40 bytes less than advertised.
> 
> I also include a patch to make use of the explicit monitor
> interface to use sniffer mode and hopefully keep injection
> working with the HW queue changes.
> 
> johannes

Oddly enough, these all applied...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
