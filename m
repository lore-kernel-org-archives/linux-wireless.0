Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:22420 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab1KURBs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 12:01:48 -0500
Date: Mon, 21 Nov 2011 12:01:45 -0500
From: Pavel Roskin <proski@gnu.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 45/77] iwlegacy: s/rx_reply/hdl/
Message-ID: <20111121120145.7820e4b2@mj> (sfid-20111121_180152_395772_2E04679E)
In-Reply-To: <20111121074432.GA2787@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
	<1321604559-10707-45-git-send-email-sgruszka@redhat.com>
	<20111118180208.6a16e68c@mj>
	<20111121074432.GA2787@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 21 Nov 2011 08:44:56 +0100
Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> On Fri, Nov 18, 2011 at 06:02:08PM -0500, Pavel Roskin wrote:
> > Why do you want it?  
> For the same reason as in other patches - for make code shorter. 
> 
> >I understand rx_reply, 
> Actually rx_reply is confusing name for interrupt handler.
> 
> > but I don't understand
> > "hdl".  Is it Hairy Definition Language? :)
> :-) it's shortcut from "handler", but you known it, don't you ?

Actually, I had that idea after a while, but first I thought about
something specific to Intel hardware.  I was also thinking of SDL and 
MDL even though I knew both were irrelevant.

-- 
Regards,
Pavel Roskin
