Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36391 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760897AbZJOPQs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2009 11:16:48 -0400
Date: Thu, 15 Oct 2009 11:10:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Azhar <Azhar.iq@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: TL-WN721N
Message-ID: <20091015151058.GC2809@tuxdriver.com>
References: <loom.20091015T161901-805@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <loom.20091015T161901-805@post.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 15, 2009 at 02:20:52PM +0000, Azhar wrote:
> Hi all,
> 
> I am looking for drivers of TL-WN721N (for linux)...i have been going through
> pages aand pages of documentation....but every other link seems to route
> here...i would really appreciate if you could guide me
> 
> Thanks
> 
> Azhar

Is it PCI?  USB?  The output of lspci or lsusb would be helpful
to know.  Of course, in most cases you distribution would have the
driver auto-loaded for you if it was supported at all...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
