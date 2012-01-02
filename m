Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:40780 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752523Ab2ABV0Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 16:26:16 -0500
Received: from compute1.internal (compute1.nyi.mail.srv.osa [10.202.2.41])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id BD06E2128E
	for <linux-wireless@vger.kernel.org>; Mon,  2 Jan 2012 16:26:15 -0500 (EST)
Message-ID: <4F0220F5.30309@fastmail.fm> (sfid-20120102_222621_402169_DFD806A2)
Date: Mon, 02 Jan 2012 21:26:13 +0000
From: Jack Stone <jwjstone@fastmail.fm>
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Oliver Neukum <oliver@neukum.org>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	USB list <linux-usb@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org> <4F02165C.1060400@fastmail.fm> <CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com> <20120102211904.GA15316@srcf.ucam.org>
In-Reply-To: <20120102211904.GA15316@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/01/12 21:19, Matthew Garrett wrote:
> On Mon, Jan 02, 2012 at 12:48:48PM -0800, Linus Torvalds wrote:
> 
>> Why are you guys making it any more complicated than that?
> 
> Because it's inadequate. You can't guarantee that we ever loaded 
> firmware. The same hardware might maintain state over warm reboots but 
> not over suspend. We never loaded the firmware loader driver. We never 
> called request_firmware(). We have no way of knowing whether the device 
> is an older one that needs firmware loading, or a newer one which has it 
> in flash.
> 

Can we tell by the USB ids that this is a device that might need
firmware and load it into memory anyway - it would use more memory but
would always work as we would have the firmware.

Thanks,

Jack
