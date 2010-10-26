Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:54706 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079Ab0JZMf4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 08:35:56 -0400
Received: from p5099b351.dip0.t-ipconnect.de ([80.153.179.81] helo=zzz.local)
	by bar.sig21.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_SHA1:16)
	(Exim 4.63)
	(envelope-from <js@sig21.net>)
	id 1PAikr-0003ZC-1u
	for linux-wireless@vger.kernel.org; Tue, 26 Oct 2010 14:35:55 +0200
Received: from js by zzz.local with local (Exim 4.72)
	(envelope-from <js@sig21.net>)
	id 1PAikq-0001Ce-RJ
	for linux-wireless@vger.kernel.org; Tue, 26 Oct 2010 14:35:52 +0200
Date: Tue, 26 Oct 2010 14:35:52 +0200
From: Johannes Stezenbach <js@sig21.net>
To: linux-wireless@vger.kernel.org
Subject: Re: Compat-wireless release for 2010-10-25 is baked
Message-ID: <20101026123552.GA4604@sig21.net>
References: <20101025190358.AEC6840F97@repository3.orbit-lab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101025190358.AEC6840F97@repository3.orbit-lab.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 25, 2010 at 03:03:57PM -0400, Compat-wireless cronjob account wrote:
> From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
>    d9f241e..e10b307  history    -> origin/history
>  + c8b020e...fd4f9b3 master     -> origin/master  (forced update)
>    b515316..229aebb  stable     -> origin/stable
>  * [new tag]         next-20101025 -> next-20101025
...
> Base tree: linux-next.git
> Base tree version: next-20101025
> compat-wireless release: compat-wireless-2010-10-22-pc

I wonder about the different tarballs in
http://wireless.kernel.org/download/compat-wireless-2.6/

compat-wireless-2010-10-25.tar.bz2
compat-wireless-2010-10-25-p.tar.bz2
compat-wireless-2010-10-25-pc.tar.bz2

Those -p and -pc postfixes are not explained in
http://wireless.kernel.org/en/users/Download


On a related note, I ran across compat-wireless-2.6.36-rc8-1-cs.tar.bz2 in
http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.36/
which is not linked on
http://wireless.kernel.org/en/users/Download/stable/#Releases
and I wonder about the -s and -cs postfixes?


Can someone shed a light on this?


Thanks
Johannes
