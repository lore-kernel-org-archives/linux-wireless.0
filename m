Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53219 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2KPN14 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 08:27:56 -0500
Message-ID: <1353072509.9490.7.camel@jlt4.sipsolutions.net> (sfid-20121116_142759_368707_E6BD4976)
Subject: Re: VHT support, take 2
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 16 Nov 2012 14:28:29 +0100
In-Reply-To: <50A4DB80.2020209@posedge.com>
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
	  (sfid-20121109_211702_930840_209B43F6) <1352492493.28302.7.camel@jlt4.sipsolutions.net>
	 <50A4DB80.2020209@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-15 at 17:39 +0530, Mahesh Palivela wrote:

> vht regulatory code already posted long back. After went through several 
> back n forth emails from Luis Rodriguez, accepted the patch.
> But not commited anywhere.
> Now I have to change that to match to new structs like chan_def etc from 
> the vht channel work patches you posted 5 days back.
> 
> Also helper funcs to replace chan->flags bit checking to dynamically 
> check channel through regulatory

Yeah, actually I'm not sure it's that easy. We'll also need per
bandwidth TX power restrictions, raise the 40 MHz bandwidth restriction
to 160 MHz (or get rid of it entirely), etc. That seems to require a new
regulatory database format?

johannes

