Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from posthamster.phnxsoft.com ([195.227.45.4]:2283 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037AbZJKLvf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 07:51:35 -0400
Message-ID: <4AD1BF06.3050103@phoenixsoftware.de>
Date: Sun, 11 Oct 2009 13:18:30 +0200
From: Tilman Schmidt <t.schmidt@phoenixsoftware.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Dave Young <hidave.darkstar@gmail.com>,
	linux-kernel@vger.kernel.org, tglx@linutronix.de,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: NOHZ: local_softirq_pending 08
References: <20091011095217.GA2200@darkstar> <1255255735.4095.53.camel@johannes.local>
In-Reply-To: <1255255735.4095.53.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 11 Oct 2009 12:08:55 +0200, Johannes Berg wrote:
> On Sun, 2009-10-11 at 17:52 +0800, Dave Young wrote:
> 
>> With kernel 2.6.32-rc3-00052-g0eca52a I got following KERN_ERR
>> messages just while using firefox:
>>
>> [  130.527399] NOHZ: local_softirq_pending 08
> 
>> Any idea? or known issue?
> 
> Are you using b43 (or wl12x1)? If so, it's a known issue, but the driver
> was recently left without an active maintainer in a brouhaha about a bug
> fix.
> 
> Cf. http://thread.gmane.org/gmane.linux.kernel.wireless.general/39440

Can you explain a bit more what that message is about?
I am encountering it in a completely different context
(PPP over ISDN) and I would like to know where to start
looking for the cause and developing a fix. The thread
on linux.kernel.wireless.general only seems to address
the specific situation in the wireless stack.

Thanks,
Tilman

