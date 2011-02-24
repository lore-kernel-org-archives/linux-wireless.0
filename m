Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32972 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454Ab1BXUCH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 15:02:07 -0500
Subject: Re: [PATCH v2] rtl8192c: fix compilation errors
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4D66B81E.8070009@lwfinger.net>
References: <1298576230.4251.5.camel@jlt3.sipsolutions.net>
	 <1298576345.4251.6.camel@jlt3.sipsolutions.net>
	 <4D66B81E.8070009@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 21:02:02 +0100
Message-ID: <1298577722.4251.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-02-24 at 13:57 -0600, Larry Finger wrote:

> Your V2 is better than the one I submitted last night as I missed the change in 
> the header file.

Oh I missed yours, but without changing the header file it still fails
to compile so ...

> Why does the PowerPC compiler flag this when the X86_64 one does not?

I have no idea, something about the section layout maybe.

johannes

