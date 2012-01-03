Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64137 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab2ACAbU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 19:31:20 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Subject: Re: loading firmware while usermodehelper disabled.
Date: Tue, 3 Jan 2012 01:31:15 +0100
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Oliver Neukum <oliver@neukum.org>,
	Matthew Garrett <mjg@redhat.com>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Greg Kroah-Hartman" <gregkh@suse.de>,
	USB list <linux-usb@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org> <201201022331.27562.marek.vasut@gmail.com> <4F023D02.1030403@fastmail.fm>
In-Reply-To: <4F023D02.1030403@fastmail.fm>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201201030131.15397.marek.vasut@gmail.com> (sfid-20120103_013149_667336_0B4D088B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 02/01/12 22:31, Marek Vasut wrote:
> >> I don't think there is anyway to avoid the memory requirement if we want
> >> to be able to resume transparently to user-space (or even resume at all
> >> in some setups).
> > 
> > Well ... injecting firmware into kernel with some userland helper just
> > before suspend is no-go?
> 
> Its a perfectly good idea but you still need the full memory requirement
> during the suspend.

Hm ... and we can't have memory type that "can be swapped-out, but must be 
loaded back before suspend" in kernel, right?

> 
> Thanks,
> 
> Jack
