Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-72-92-88-10.phlapa.fios.verizon.net ([72.92.88.10]:42754
	"EHLO smtp.roinet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbZKRPfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 10:35:08 -0500
Message-ID: <4B04142F.6060101@roinet.com>
Date: Wed, 18 Nov 2009 10:35:11 -0500
From: David Acker <dacker@roinet.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	madwifi-users@lists.sourceforge.net,
	Andrey Yurovsky <andrey@cozybit.com>,
	madwifi-devel@lists.sourceforge.net
Subject: Re: [Madwifi-devel] Survey: What are you using MadWifi for, and why?
References: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de>	<43e72e890911161701p61d0db5ag25a1459f900b3ab7@mail.gmail.com>	<4B02DFF4.1060509@roinet.com>	<45e8e6c40911171257m7c687380k6e6e2677fd11f851@mail.gmail.com>	<43e72e890911171337p4b0d97fcp844266137bb51b56@mail.gmail.com>	<4B03193E.2080304@roinet.com>	<43e72e890911171345q2dc59d66g6ac2a9eec04c577c@mail.gmail.com> <4B031B48.1090105@roinet.com> <4B03304C.2000403@openwrt.org>
In-Reply-To: <4B03304C.2000403@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> David Acker wrote:
>> Also, I don't know if ath5k will work on products based on 
>> Atheros WiSOCs like Ubiquiti's PicoStation and Bullet.
> I have some work in progress patches for that. They won't work yet (in
> fact I just ported them to a newer version of compat-wireless without
> testing, so they probably won't even compile yet *g*), but according to
> my rough estimation, they contain about 70-80% of what's necessary to
> support this hw. You can find them at http://nbd.name/ath5k-wisoc.tar.gz
> If anybody is seriously interested in hacking on this stuff, please take
> a look at this patch series and contact me afterwards...
Interesting.  Time permitting, I will try to take a look at this a bit 
this week.


> 
>> A lesser issue 
>> (more of a pain for me than an ath5k issue) is that I have some 
>> platforms that use an older kernel and moving up to a newer kernel will 
>> have to be done without hardware vendor support.
> What platforms with old kernels are you using? Maybe some of them are
> being worked on in OpenWrt already ;)
Perhaps.  I have a CM-X255 
http://www.compulab.co.il/x255/html/x255-cm-datasheet.htm combined with 
a custom board for PCI with an intel pro 100 and a miniPCI slot holding 
a ubiquiti card.

-ack
