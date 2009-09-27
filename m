Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:55028 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZI0Nbm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2009 09:31:42 -0400
Date: Sun, 27 Sep 2009 15:32:05 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [bisected] Wireless regression in 2.6.32-git
Message-ID: <20090927153205.4e3a1ee9@infradead.org>
In-Reply-To: <8db1092f0909270624l4fc46734u6a91f7cc7ffb0c72@mail.gmail.com>
References: <20090927151855.29efcc53@infradead.org>
	<8db1092f0909270624l4fc46734u6a91f7cc7ffb0c72@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 27 Sep 2009 15:24:10 +0200
Maciej Rutecki <maciej.rutecki@gmail.com> wrote:

> Did You have similar messages in dmesg like this:
> 
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2089
> (use WPA)

nope I don't get a Reason 6 disconnect...

(I get a reason 3 local choice, but that's true for working and
non-working both)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
