Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47560 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab0BVPPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 10:15:46 -0500
Date: Mon, 22 Feb 2010 10:00:06 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, florian@mickler.org,
	linux-wireless@vger.kernel.org,
	Randy Dunlap <rdunlap@xenotime.net>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/2] Document the rfkill sysfs ABI
Message-ID: <20100222150006.GA2988@tuxdriver.com>
References: <1266702045-6062-1-git-send-email-florian@mickler.org> <1266702045-6062-2-git-send-email-florian@mickler.org> <1266704345.32739.0.camel@jlt3.sipsolutions.net> <1266746930.18491.1.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1266746930.18491.1.camel@violet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 21, 2010 at 11:08:50AM +0100, Marcel Holtmann wrote:
> Hi Johannes,
> 
> > > This moves sysfs ABI info from Documentation/rfkill.txt to the
> > > ABI subfolder and reformats it.
> > > 
> > > Signed-off-by: Florian Mickler <florian@mickler.org>
> > 
> > This is fine with me.
> 
> we have to be careful here. Some of these sysfs details needs to be
> deprecated and removed. Applications should use /dev/rfkill actually.

Maybe all of it should be in "obsolete"?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
