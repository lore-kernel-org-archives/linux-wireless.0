Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:34207 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965267AbbLRVBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 16:01:49 -0500
Received: by mail-pf0-f175.google.com with SMTP id u7so7916111pfb.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2015 13:01:48 -0800 (PST)
Date: Fri, 18 Dec 2015 13:01:46 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: linux-mtd@lists.infradead.org,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5] mtd: nand: bcm47xx: use the mtd instance embedded in
 struct nand_chip
Message-ID: <20151218210146.GO10460@google.com> (sfid-20151218_220156_921985_89C0BB5B)
References: <1450467498-35553-1-git-send-email-computersforpeace@gmail.com>
 <20151218215000.2b0adda9@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151218215000.2b0adda9@bbrezillon>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 18, 2015 at 09:50:00PM +0100, Boris Brezillon wrote:
> On Fri, 18 Dec 2015 11:38:18 -0800
> Brian Norris <computersforpeace@gmail.com> wrote:
> 
> > From: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > 
> > struct nand_chip now embeds an mtd device. Make use of this mtd instance.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> 
> Looks good to me, not we can have both a SoB and an AB tag coming from
> the same person, but
> 
> Acked-by: Boris Brezillon <boris.brezillon@free-elctrons.com>

Good point. I guess the ack can just assure me I didn't screw up your
work *too* badly :)

Applied without the duplicate tag
