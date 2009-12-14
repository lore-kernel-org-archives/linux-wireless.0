Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50400
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752721AbZLNTqu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 14:46:50 -0500
Date: Mon, 14 Dec 2009 11:46:52 -0800 (PST)
Message-Id: <20091214.114652.243547684.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: Revised wireless tree management practices
From: David Miller <davem@davemloft.net>
In-Reply-To: <200912142042.13251.bzolnier@gmail.com>
References: <200912142016.00169.bzolnier@gmail.com>
	<20091214.112304.26981627.davem@davemloft.net>
	<200912142042.13251.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Mon, 14 Dec 2009 20:42:13 +0100

> However looking at "Top non-author signoffs in 2.6.31" [1]:
> 
> David S. Miller     964 10.1%
> Ingo Molnar         948 9.9%
> Greg Kroah-Hartman  582 6.1%
> ...
> 
> it seems that there are people able to do large upstream merges in much
> more transparent and reviewer-friendly way so it is not like there exists
> some real physical barrier for not even trying to do things better..

Greg (USB, staging) and Ingo (scheduler, perf, tracing, x86) each work
in several disconnected areas, and have you seen the size of the
staging tree merges? :-)
