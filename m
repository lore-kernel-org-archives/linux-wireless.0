Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:20226 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbZJUUW5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2009 16:22:57 -0400
Subject: Re: TL-WN721N
From: Pavel Roskin <proski@gnu.org>
To: Azhar <Azhar.iq@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20091018T103209-571@post.gmane.org>
References: <loom.20091015T161901-805@post.gmane.org>
	 <20091015151058.GC2809@tuxdriver.com>
	 <loom.20091018T103209-571@post.gmane.org>
Content-Type: text/plain
Date: Wed, 21 Oct 2009 16:23:00 -0400
Message-Id: <1256156580.1480.2.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-10-18 at 08:33 +0000, Azhar wrote:

> ndiswrapper -l
> 
> WARNING: All config files need .conf: /etc/modprobe.d/ndiswrapper, it will be
> ignored in a future release.

This has been fixed in the ndiswrapper subversion repository.  Next
version of ndiswrapper will use /etc/modprobe.d/ndiswrapper.conf

-- 
Regards,
Pavel Roskin
