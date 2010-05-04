Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60165 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab0EDRaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 13:30:15 -0400
Date: Tue, 4 May 2010 13:17:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 2/4] rt2x00: Enable RT30xx by default.
Message-ID: <20100504171720.GA21043@tuxdriver.com>
References: <1272919385-18004-1-git-send-email-gwingerde@gmail.com>
 <1272919385-18004-3-git-send-email-gwingerde@gmail.com>
 <1272920358.4907.3.camel@mj>
 <201005040008.36956.s.L-H@gmx.de>
 <1272926643.6239.1.camel@mj>
 <4BDF94FD.7050606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4BDF94FD.7050606@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 04, 2010 at 05:31:09AM +0200, Gertjan van Wingerde wrote:

> To be honest, at the moment I would just change the default from 'n' to 'y'
> for one kernel cycle, and then remove the entire option in the next kernel
> release.
> This is just to make it easier to revert back if for some reasons problems
> arise with the rt30xx support.
> The overall goal is to get rid of all these of the RT2800PCI_yyy and RT2800USB_zzz
> symbols, but that can only happen if the devices denoted by these symbols
> are properly supported.
> 
> John, I leave it up to you, but for me my original patch should be merged, and
> I'll send an equivalent patch for Stefan's one for the next kernel release.

Since the options are already inside "if RT2800PCI" and "if RT2800USB"
blocks, I don't see why anyone should object to the boolean defaulting
to 'y'.  It's not as if you are enabling a new driver.

I think Gertjan's proposal seems reasonable -- just don't forget! :-)
I would suggest a feature-removal-schedlue.txt patch, but I don't
know that it is worth the trouble.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
