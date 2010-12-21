Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42581 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0LUKln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 05:41:43 -0500
Subject: Re: vendor IEs?
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTi=n4pUEy_3PYX=7wbY+zR4D8=EGDNN-NtqhFs2q@mail.gmail.com>
References: <AANLkTi=n4pUEy_3PYX=7wbY+zR4D8=EGDNN-NtqhFs2q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 11:41:40 +0100
Message-ID: <1292928100.3563.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-12-19 at 16:53 -0800, Daniel Halperin wrote:
> Is there a compiled list of vendor-specific IEs out there?  Googling
> didn't offer much help.

I'm not aware of any list, nor can there really be one since everybody
who has an OUI is free to define their own IEs.

That said, some of them are of course mostly standardised, like the WFA
ones for WPA, WSC/WPS and P2P for instance. I don't think there's a even
a comprehensive list of WFA ones though other than in what you get by
combining all those standards.

johannes

