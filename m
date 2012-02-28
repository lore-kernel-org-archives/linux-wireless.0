Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34482 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab2B1GZF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 01:25:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1S2GUh-0003GQ-96
	for linux-wireless@vger.kernel.org; Tue, 28 Feb 2012 07:25:03 +0100
Received: from ttihfwgw.tieto.com ([194.197.79.18])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2012 07:25:03 +0100
Received: from anand.jain by ttihfwgw.tieto.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2012 07:25:03 +0100
To: linux-wireless@vger.kernel.org
From: Anand Jain <anand.jain@tieto.com>
Subject: Re: A new driver is going to be released
Date: Tue, 28 Feb 2012 05:45:26 +0000 (UTC)
Message-ID: <loom.20120228T063911-173@post.gmane.org> (sfid-20120228_072510_566943_461EC540)
References: <CAMG6FYiNW-1ijghpgQ6R_9HujVEp8d53DQ-vjfJrw_hZamM8Jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dmitry Tarnyagin <abi.dmitryt@...> writes:

> 
> Hi,
> 
> I'm about to release cw1200 driver to the community (more or less
> latest code is available here:
>
http://www.igloocommunity.org/gitweb/?p=kernel/igloo-kernel.git;a=shortlog;h=refs/heads/linux-3.0-ux500
> as well).
> 
> Technical question: how is it usually done in terms of commit history?
> Should I preserve the history and release all the changes in the
> driver separately or should I squash everything to a single commit
> or...?
> 
> Thank you and with best regards,
> Dmitry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Hi,
 we are exploring the cw1200 driver and found in TODO that IBSS is not
implemented. So can you guide us if we can implement/enhance the same for
Snowball board in ICS code.

thanks
Anand


