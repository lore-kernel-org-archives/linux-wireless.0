Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34995 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab0HTCl1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Aug 2010 22:41:27 -0400
Date: Thu, 19 Aug 2010 17:15:31 -0700
From: Greg KH <gregkh@suse.de>
To: Jerry-RealtekFAE <jerry-chuang@realtek.com>
Cc: Gauss Frank <gaussfrank@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-wireless@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	wlanfae <wlanfae@realtek.com>,
	Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Subject: Re: Hi,Linus Torvalds. There's a problem in r8192u driver in Linux
 new kernel.
Message-ID: <20100820001531.GA2312@suse.de>
References: <AANLkTi=1NaRKc8QrQBGwU+c_17D86_Cqu9MopR_rso0H@mail.gmail.com>
 <AANLkTin3qXSbuWejTGJzz6cO6fycK4HqU4gn4gF1wEdp@mail.gmail.com>
 <20100812161907.GA25082@suse.de>
 <76C6BFFEAAA24679B55CBB186C084833@cnfaec24b87a3f>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <76C6BFFEAAA24679B55CBB186C084833@cnfaec24b87a3f>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 16, 2010 at 05:37:09PM +0800, Jerry-RealtekFAE wrote:
> Dear Sir/Madam
> 
> Please find the RTL8192U latest Linux driver in the attachment.
> Please try it on Kernel 2.6.35-1 again.

Could you send patches updating the in-kernel version of this driver to
your latest version?  That would help everyone out in the end.

thanks,

greg k-h
