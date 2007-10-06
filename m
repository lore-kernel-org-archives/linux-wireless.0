Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.225]:26584 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbXJFBVl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2007 21:21:41 -0400
Received: by wx-out-0506.google.com with SMTP id h31so634485wxd
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2007 18:21:40 -0700 (PDT)
Date: Fri, 5 Oct 2007 21:23:04 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 0/6] ath5k: initvals, radar, promiscuous bug and
	multicast
Message-ID: <20071006012304.GG25022@pogo> (sfid-20071006_022143_766445_C3E53AA4)
References: <20071006010449.GA25022@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071006010449.GA25022@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 05, 2007 at 09:04:49PM -0400, Luis R. Rodriguez wrote:
> This patch series adds a few things which have been sitting in my
> queue. The most important change is the proper fix for the promiscuous
> bug.

And and forgot to add that I've tested the driver now on big endian.
I'm able to auth and assoc but the big-endian box is in an area where
the DHCP server sends the ACK to the IP and not broadcast so haven't
tested further. I can also tcpdump and scan well.

I'll keep testing as we go. This box will eventually be available of 
anyone wanting to test on big endian.

  Luis
