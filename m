Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44061 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbYJFUcJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 16:32:09 -0400
Date: Mon, 6 Oct 2008 16:31:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Greg KH <greg@kroah.com>, Kalle Valo <kalle.valo@iki.fi>,
	proski@gnu.org, linux-wireless@vger.kernel.org
Subject: Re: at76_usb driver status
Message-ID: <20081006203118.GG3448@tuxdriver.com> (sfid-20081006_223213_249783_E57EA54A)
References: <20081002210742.GA27221@kroah.com> <87y713y48r.fsf@nokia.com> <20081005061603.GB28533@kroah.com> <1223306593.31040.33.camel@dhcp-100-3-195.bos.redhat.com> <20081006183520.GA17647@kroah.com> <1223323940.31717.3.camel@dhcp-100-3-195.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223323940.31717.3.camel@dhcp-100-3-195.bos.redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 06, 2008 at 04:12:20PM -0400, Dan Williams wrote:
> On Mon, 2008-10-06 at 11:35 -0700, Greg KH wrote:

> > I'll gladly drop it from drivers/staging when the "real" version hits
> > mainline, until then, it should stay in staging, as that is the whole
> > point of it.
> 
> It does nobody any good if (a) the drivers are _never_ going to go
> upstream, and (b) if the drivers aren't going to get any attention in
> their current form because of (a).
> 
> I don't care if the driver allows peoples hardware to work; I want a
> driver that makes peoples hardware work _well_.  Out of tree drivers
> that are never going upstream will not work well.

I think/thought the main point of -staging was to give drivers
visibility in hopes of people working to fix them.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
