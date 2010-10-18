Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40277 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab0JRVCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 17:02:52 -0400
Date: Mon, 18 Oct 2010 17:02:09 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: marcel@holtmann.org, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, davem@davemloft.net
Subject: Re: pull request: bluetooth-2.6 2010-10-18
Message-ID: <20101018190208.GA3080@vigoh>
References: <20101018055540.GA13511@vigoh>
 <20101018200830.GA2443@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101018200830.GA2443@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* John W. Linville <linville@tuxdriver.com> [2010-10-18 16:08:31 -0400]:

> On Mon, Oct 18, 2010 at 03:55:40AM -0200, Gustavo F. Padovan wrote:
> > Hi John,
> > 
> > Not sure if we still have time for a last minute fix, but here goes a
> > fix for a NULL dereference in L2CAP layer for 2.6.36-rc8. Please also let
> > me know if this is the right way to handle such last minute fix. Maybe you
> > should want this directly through Dave. 
> > 
> > Thanks.
> 
> The fix seems fine to me.  Given the short schedule, it might be best
> to skip the middleman and have Dave pull directly from you?
> 
> Dave, be forewarned that Gustavo has based his tree off 2.6.36-rc8 --
> dunno if you are ready to pull that into net-2.6 or not.

If you guys think that rebase against Linus' tree could be a problem, I
can start to base bluetooth-2.6 against net-2.6 for the next pull
requests.

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
