Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.184]:31519 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbYBYUx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 15:53:59 -0500
Received: by gv-out-0910.google.com with SMTP id s4so693048gve.37
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 12:53:57 -0800 (PST)
Subject: Re: [PATCH 05/13 v2] o11s: mesh.c, support functions for mesh
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1203697511.7082.73.camel@johannes.berg>
References: <47be7736.09d7720a.37a2.6115@mx.google.com>
	 (sfid-20080222_071818_973520_9B55DA17)  <1203697511.7082.73.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 12:55:33 -0800
Message-Id: <1203972933.6929.75.camel@localhost> (sfid-20080225_205402_647036_A925720F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-02-22 at 17:25 +0100, Johannes Berg wrote:
> > +	 *   - Sync support required from peer
> > +	 *   - MDA enabled
> > +	 * - Power management control on fc
> > +	 */
> > +		return true;
> 
> Can the comment be before the if please?

Ok, will make a patch when the series you submitted make it to wireless
testing.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


