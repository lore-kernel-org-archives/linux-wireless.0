Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:51072 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751174AbXLSJZ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 04:25:27 -0500
Date: Wed, 19 Dec 2007 10:20:16 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Greg KH <gregkh@suse.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/8] debugfs: allow access to signed values
Message-ID: <20071219102016.7785c4d3@morte> (sfid-20071219_092533_186825_A2B40D8D)
In-Reply-To: <20071219064510.GA18876@suse.de>
References: <20071219001955.055692620@polimi.it>
	<20071219012739.6dcdd150@morte>
	<20071219064510.GA18876@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 18 Dec 2007 22:45:10 -0800
Greg KH <gregkh@suse.de> wrote:

> On Wed, Dec 19, 2007 at 01:27:39AM +0100, Stefano Brivio wrote:
> > Add debugfs_create_s{8,16,32,64}. For these to work properly, we need to remove
> > a cast in libfs.
> > 
> > Cc: Johannes Berg <johannes@sipsolutions.net>
> > To: Greg Kroah-Hartman <gregkh@suse.de>
> > Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> > ---
> > Greg,
> > 
> > here comes an implementation of debugfs_create_s{8,16,32,64} which avoids code
> > duplication, suggested by Johannes Berg. We would need this to be merged to
> > 2.6.25, as we need those functions to be available for rc80211-pid, the new
> > mac80211 rate control algorithm.
> 
> Looks good to me, do you want me to add this to my tree and send it to
> Linus when 2.6.25 opens up, or do you want this to go through the
> wireless tree as you have patches relying on it?

I have one patch (rate control rework, 8/8) relying on it. Let's ask John. John,
what's the best for you?

> Whatever works the best for you is fine for me.  If the wireless tree,
> feel free to add:
> 	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> to the patch.

Thanks. I'm going to resend the patch to John with your Signed-off-by -- in case.


--
Ciao
Stefano
