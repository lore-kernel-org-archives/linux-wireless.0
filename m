Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:51503 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753037Ab2ABUlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 15:41:06 -0500
Received: from compute6.internal (compute6.nyi.mail.srv.osa [10.202.2.46])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id DEF1720C9A
	for <linux-wireless@vger.kernel.org>; Mon,  2 Jan 2012 15:41:03 -0500 (EST)
Message-ID: <4F02165C.1060400@fastmail.fm> (sfid-20120102_214110_398618_019D1C25)
Date: Mon, 02 Jan 2012 20:41:00 +0000
From: Jack Stone <jwjstone@fastmail.fm>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
	Oliver Neukum <oliver@neukum.org>,
	Matthew Garrett <mjg@redhat.com>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	USB list <linux-usb@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/01/12 16:54, Alan Stern wrote:
> What Oliver and I have been discussing is delaying the probe call until
> after resume is finished, when userspace is back up and everything is
> operating normally again.  It would be more awkward than the current
> code, but it definitely can be done.

What about the case where the firmware that needs to be loaded is on the
USB device that needs the firmware. This can be resolved at boot using
an initrd but at resume time we don't have that.

Thanks,

Jack

