Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56069 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab0JRUPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 16:15:10 -0400
Date: Mon, 18 Oct 2010 16:08:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: marcel@holtmann.org, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, davem@davemloft.net
Subject: Re: pull request: bluetooth-2.6 2010-10-18
Message-ID: <20101018200830.GA2443@tuxdriver.com>
References: <20101018055540.GA13511@vigoh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101018055540.GA13511@vigoh>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 18, 2010 at 03:55:40AM -0200, Gustavo F. Padovan wrote:
> Hi John,
> 
> Not sure if we still have time for a last minute fix, but here goes a
> fix for a NULL dereference in L2CAP layer for 2.6.36-rc8. Please also let
> me know if this is the right way to handle such last minute fix. Maybe you
> should want this directly through Dave. 
> 
> Thanks.

The fix seems fine to me.  Given the short schedule, it might be best
to skip the middleman and have Dave pull directly from you?

Dave, be forewarned that Gustavo has based his tree off 2.6.36-rc8 --
dunno if you are ready to pull that into net-2.6 or not.

John

>   Linux 2.6.36-rc8 (2010-10-14 16:26:43 -0700)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git master
> 
> Nathan Holstein (1):
>       Bluetooth: fix oops in l2cap_connect_req
> 
>  net/bluetooth/l2cap.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> -- 
> Gustavo F. Padovan
> ProFUSION embedded systems - http://profusion.mobi
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
