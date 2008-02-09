Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.syneticon.net ([213.239.212.131]:34646 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbYBIKJ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Feb 2008 05:09:57 -0500
Message-ID: <47AD7BEF.9000709@wpkg.org> (sfid-20080209_101002_752721_AA53541D)
Date: Sat, 09 Feb 2008 11:09:51 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: prism54: Out of memory, cannot handle oid, card/socket may be
 faulty, or IRQ line too busy
References: <47ACD136.4030705@wpkg.org> <20080208221009.GA2919@tuxdriver.com>
In-Reply-To: <20080208221009.GA2919@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville schrieb:
> On Fri, Feb 08, 2008 at 11:01:26PM +0100, Tomasz Chmielewski wrote:
>> I just wanted to use a mini-PCI card using a prism54 module - however, it 
>> fails to bring the interface up with "Out of memory, cannot handle oid" and 
>> "Your card/socket may be faulty, or IRQ line too busy" messages.
> 
> I vaguely recall seeing an error like that when I used the wrong
> firmware.  What firmware are you using?

This is my card:

# lspci -nn
(...)
00:02.0 Network controller [0280]: Intersil Corporation ISL3890 [Prism 
GT/Prism Duette]/ISL3886 [Prism Javelin/Prism Xbow] [1260:3890] (rev 01)

According to http://prism54.org/newdrivers.html, my card is among the 
supported devices, and I should use version 2.7.0.0 for PCI devices 
firmware:

PCI Vendor (hex)	PCI Product (hex)	Common name
1260	3890	Generic ISL3890


It doesn't work and says "Your card/socket may be faulty, or IRQ line 
too busy". With 2.7.0.0 firmware, it doesn't say "out of memory" anymore.

Are there more things to be done to make this card work?


-- 
Tomasz Chmielewski
http://wpkg.org
