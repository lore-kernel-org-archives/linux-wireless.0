Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57316 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbZESRpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 13:45:11 -0400
Date: Tue, 19 May 2009 13:33:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ipw2100: Oops, Data bus error
Message-ID: <20090519173309.GC2691@tuxdriver.com>
References: <4A12E0F3.2040209@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A12E0F3.2040209@wpkg.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2009 at 06:40:19PM +0200, Tomasz Chmielewski wrote:
> I'm not sure if it's interesting or not.
>
> On ASUS WL-500gP (MIPS platform, with OpenWRT patches), running 2.6.29.3 
> kernel, I'm getting an Oops (see below) when I remove the ipw2100 module 
> and modprobe it again.
> Let me know if I should decode the Oops etc., or if has perhaps something to do with the board
> not fully supported by the upstream kernel, and just leave it.

Please decode the oops... :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
