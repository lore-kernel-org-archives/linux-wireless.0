Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.syneticon.net ([213.239.212.131]:33601 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbYBHXdw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 18:33:52 -0500
Message-ID: <47ACE6DA.30001@wpkg.org> (sfid-20080208_233357_058797_C2919D42)
Date: Sat, 09 Feb 2008 00:33:46 +0100
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

As specified here:

http://prism54.org/fullmac.html
Only PCI cards with an ISL3877, ISL3880 and ISL3890 work -> I used 
Version 1.0.4.3 (for ISL3880 and ISL3890)


My card is:

Intersil Corporation ISL3890 [Prism GT/Prism Duette]/ISL3886


Is it ISL3890 or ISL3886?

Maybe I should use "Version 2.7.0.0 for PCI devices" firmware?

Will check tomorrow.


-- 
Tomasz Chmielewski
http://wpkg.org
