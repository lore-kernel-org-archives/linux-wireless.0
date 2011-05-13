Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54710 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522Ab1EMOac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 10:30:32 -0400
Received: by pvg12 with SMTP id 12so1174981pvg.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 07:30:31 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19917.16659.841512.824060@gargle.gargle.HOWL> (sfid-20110513_163036_011510_0028FDCD)
Date: Fri, 13 May 2011 20:02:51 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: concurrency advertising -- driver maintainers
In-Reply-To: <1305294053.3487.37.camel@jlt3.sipsolutions.net>
References: <1305290657.3487.32.camel@jlt3.sipsolutions.net>
	<1305294053.3487.37.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2011-05-13 at 14:44 +0200, Johannes Berg wrote:
> 
> > The affected drivers, as far as I can tell, are:
> 
> I forgot ath9k_htc, which needs to advertise something afaict (two
> interfaces seem to be supported)

The limitation of two is artificial, more can actually be supported.
The firmware has to be updated, though.

Sujith
