Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:1049 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbYKOCaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 21:30:25 -0500
Date: Fri, 14 Nov 2008 21:29:13 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Dan McGee <dpmcgee@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Sujith <m.sujith@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Message-ID: <20081115022913.GC10702@hash.localnet> (sfid-20081115_033046_813480_BC0217B5)
References: <43e72e890811141029q24ad722fi6a7ae1e7dcd463bd@mail.gmail.com> <18717.50308.330801.765686@localhost.localdomain> <43e72e890811141037j5328f71fx7badb6f2b0e0831d@mail.gmail.com> <449c10960811141133o6d34c53fke3894a32cc1e5b8b@mail.gmail.com> <b6c5339f0811141233g38086cc0ybb69eebdbab7ae60@mail.gmail.com> <43e72e890811141241k7ae83fc3qe90e2e42d61b8df6@mail.gmail.com> <43e72e890811141313t33b6a3edo86488bea9a7b3371@mail.gmail.com> <449c10960811141625o171d1e31v974d2f921f5a825@mail.gmail.com> <20081115003608.GK27642@tesla> <449c10960811141805w428df33ak2f98651abb7403e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <449c10960811141805w428df33ak2f98651abb7403e6@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2008 at 08:05:09PM -0600, Dan McGee wrote:
> On Fri, Nov 14, 2008 at 6:36 PM, Luis R. Rodriguez
> Of course, now that I have a kernel with full debug symbols, I can't
> get it to oops. Figures. I'll keep you updated if I see this error
> again.

Grasping at straws, is there any chance your kernel didn't match up 
with the compiled modules from compat-wireless?  For example, you 
reconfigured the kernel without rebuilding it, then compat-wireless
picked up your .config?  I suppose that could lead to structures being 
defined with wrong offsets... 

-- 
Bob Copeland %% www.bobcopeland.com

