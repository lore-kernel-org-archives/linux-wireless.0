Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 174-143-244-95.static.cloud-ips.com ([174.143.244.95]:59762
	"EHLO mail.catnarok.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab3IVMyk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Sep 2013 08:54:40 -0400
Date: Sun, 22 Sep 2013 12:32:00 +0000
From: Michael Stolovitzsky <emestee@catnarok.net>
To: linux-wireless@vger.kernel.org
Subject: Re: brcmsmac causes soft lockup in 3.12-rc1
Message-ID: <20130922123200.GA17832@mail.catnarok.net> (sfid-20130922_145444_552128_A2623047)
References: <20130921223440.GA5297@mail.catnarok.net>
 <loom.20130922T072315-740@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <loom.20130922T072315-740@post.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 22, 2013 at 05:33:29AM +0000, Adam Honse wrote:
> I'm having the same issues on my laptop.  Under Debian, Ubuntu, and Arch I
> had the same problem in every kernel release I tried brcmsmac on in that the
> range is very poor.  My router in the basement was intermittent upstairs in
> the room directly above the router, and got barely enough signal to work
> reliably sitting next to it.  I just switched the machine back to Ubuntu
> (GNOME Remix) today to test the Radeon drivers but upon installing 3.12 I'm
> getting the same soft-lockup bug, crashes the whole PC before I can log in
> and even see what's going on.  The closed source Broadcom STA driver works
> fine on supported kernels.
> 

Please post lspci -vnn, I wanna see if the hardware is identical.
