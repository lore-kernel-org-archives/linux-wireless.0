Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab0HTDeh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Aug 2010 23:34:37 -0400
Date: Thu, 19 Aug 2010 20:31:12 -0700
From: Greg KH <gregkh@suse.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jerry-RealtekFAE <jerry-chuang@realtek.com>,
	Gauss Frank <gaussfrank@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-wireless@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	wlanfae <wlanfae@realtek.com>,
	Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Subject: Re: Hi,Linus Torvalds. There's a problem in r8192u driver in Linux
	new kernel.
Message-ID: <20100820033112.GA5821@suse.de>
References: <AANLkTi=1NaRKc8QrQBGwU+c_17D86_Cqu9MopR_rso0H@mail.gmail.com> <AANLkTin3qXSbuWejTGJzz6cO6fycK4HqU4gn4gF1wEdp@mail.gmail.com> <20100812161907.GA25082@suse.de> <76C6BFFEAAA24679B55CBB186C084833@cnfaec24b87a3f> <20100820001531.GA2312@suse.de> <4C6DEF52.6050407@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C6DEF52.6050407@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 19, 2010 at 09:58:26PM -0500, Larry Finger wrote:
> On 08/19/2010 07:15 PM, Greg KH wrote:
> > On Mon, Aug 16, 2010 at 05:37:09PM +0800, Jerry-RealtekFAE wrote:
> >> Dear Sir/Madam
> >>
> >> Please find the RTL8192U latest Linux driver in the attachment.
> >> Please try it on Kernel 2.6.35-1 again.
> > 
> > Could you send patches updating the in-kernel version of this driver to
> > your latest version?  That would help everyone out in the end.
> 
> I have a copy of the driver that Realtek calls the r8712 for the RTL8192 USB
> devices. All of the dead code and the unneeded configuration sections have been
> removed. It will be submitted to staging as soon as Realtek signs off on the
> copyright info. For some reason, it has taken them several weeks and I still
> have no answer. This new driver is stable - the connection stays up for days. I
> expect that it will replace the current one in staging.

Wonderful, that's great news.

Jerry, any word on getting the copyright sign off moved along?

thanks,

greg k-h
