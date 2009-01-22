Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:37309 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbZAVQdU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 11:33:20 -0500
Subject: Re: [Orinoco-devel] [PATCH] orinoco: trivial cleanup in
 alloc_orinocodev
From: Pavel Roskin <proski@gnu.org>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>,
	orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <87iqo7lmtu.fsf@litku.valot.fi>
References: <200901212155.32754.arvidjaar@mail.ru>
	 <1232569292.10843.13.camel@dv>  <87iqo7lmtu.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 11:33:16 -0500
Message-Id: <1232641996.5749.0.camel@dv> (sfid-20090122_173324_559721_E7078172)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-01-22 at 11:19 +0200, Kalle Valo wrote:
> Pavel Roskin <proski@gnu.org> writes:
> 
> > By the way, I made a patch that adds all C sources in
> > drivers/net/wireless/orinoco and ran it through checkpatch.pl.
> 
> You can use checkpatch's --file argument directly, no need to create
> patches manually :)

Thanks.  Doing it now!

-- 
Regards,
Pavel Roskin
