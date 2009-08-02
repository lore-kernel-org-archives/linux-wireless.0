Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f200.google.com ([209.85.222.200]:40313 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZHBO1Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 10:27:16 -0400
Received: by pzk38 with SMTP id 38so1778933pzk.33
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2009 07:27:16 -0700 (PDT)
Message-ID: <4A75A0A8.5030406@lwfinger.net>
Date: Sun, 02 Aug 2009 09:20:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Correia <luis.f.correia@gmail.com>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: Unsupported PHY on B43
References: <efe7343f0908020214m6d8b2518n51d4264943ce273a@mail.gmail.com>	 <1249204732.2007.49.camel@johannes.local>	 <efe7343f0908020226n4b693defv38546a6f8aa1cfd9@mail.gmail.com> <1249205597.2007.50.camel@johannes.local>
In-Reply-To: <1249205597.2007.50.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> 
> Don't hold your breath -- nobody's working on it. I also really want it
> working, but since nobody seems even interested in writing the driver,
> we've halted the reverse engineering effort.

I have a vested interest in getting the LP PHY (type 5) code done as I
have one of those devices. As a result, I'm deliberately not working
on the RE for the 11n PHYs until the LP PHY code is working. If that
was not clear enough, then let me restate it: "If you want code for
Broadcom devices with ID 4322 and higher, you are going to have to do
the LP code first."

Larry

