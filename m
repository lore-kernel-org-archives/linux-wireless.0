Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaLFRvg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2014 12:51:36 -0500
Date: Sat, 6 Dec 2014 09:51:35 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: parthsane@laer.in
Cc: Felix Fietkau <nbd@openwrt.org>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Driverdev devel <driverdev-devel@linuxdriverproject.org>,
	linux-wireless@vger.kernel.org
Subject: Re: My new email + some notes on mt7601
Message-ID: <20141206175135.GA27544@kroah.com> (sfid-20141206_185246_392221_CBBCFA9B)
References: <0b2102651a76997bd04f6be7e98d3ac0@laer.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0b2102651a76997bd04f6be7e98d3ac0@laer.in>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 04, 2014 at 09:54:29AM +0000, parthsane@laer.in wrote:
> Hi again,
> Please note my new email parthsane@laer.in . Also If you guys don't know
> there's a working source supplied by mediatek for mt7601. Please find the
> attached tarball. Also please apply this patch I mentioned about earlier.
> It's at https://gist.github.com/Boggartfly/b18bd86b8eb60fabe160
> 
> rt_linux.h has the following path in the driver directory.
> 
> /include/os/rt_linux.h
> 
> After you replace the patched file everything works and compiles
> successfully!! Any pointers on what should be done to make it kernel
> compatible?

Let's wait to see if we have a "real" driver support working in the tree
soon before adding this huge driver to staging, where it will take a
long time to clean up and get merged "properly".

thanks,

greg k-h
