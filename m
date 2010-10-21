Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34513
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583Ab0JUHya (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 03:54:30 -0400
Date: Thu, 21 Oct 2010 00:54:53 -0700 (PDT)
Message-Id: <20101021.005453.193707125.davem@davemloft.net>
To: padovan@profusion.mobi
Cc: linville@tuxdriver.com, marcel@holtmann.org,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth-2.6 2010-10-18
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101018190208.GA3080@vigoh>
References: <20101018055540.GA13511@vigoh>
	<20101018200830.GA2443@tuxdriver.com>
	<20101018190208.GA3080@vigoh>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Gustavo F. Padovan" <padovan@profusion.mobi>
Date: Mon, 18 Oct 2010 17:02:09 -0200

> * John W. Linville <linville@tuxdriver.com> [2010-10-18 16:08:31 -0400]:
> 
>> On Mon, Oct 18, 2010 at 03:55:40AM -0200, Gustavo F. Padovan wrote:
>> > Hi John,
>> > 
>> > Not sure if we still have time for a last minute fix, but here goes a
>> > fix for a NULL dereference in L2CAP layer for 2.6.36-rc8. Please also let
>> > me know if this is the right way to handle such last minute fix. Maybe you
>> > should want this directly through Dave. 
>> > 
>> > Thanks.
>> 
>> The fix seems fine to me.  Given the short schedule, it might be best
>> to skip the middleman and have Dave pull directly from you?
>> 
>> Dave, be forewarned that Gustavo has based his tree off 2.6.36-rc8 --
>> dunno if you are ready to pull that into net-2.6 or not.
> 
> If you guys think that rebase against Linus' tree could be a problem, I
> can start to base bluetooth-2.6 against net-2.6 for the next pull
> requests.

I've now pulled this.
