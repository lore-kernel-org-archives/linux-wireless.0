Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:50706 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892AbXEKJgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2007 05:36:54 -0400
Message-ID: <46443932.40506@warmcat.com>
Date: Fri, 11 May 2007 10:36:50 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>, Jiri Benc <jbenc@suse.cz>,
	jketreno <jketreno@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: Specifing rate control algorithm?
References: <464253CE.2030504@linux.intel.com> <20070510132756.2ca660a0@midnight.suse.cz> <46434596.6010908@linux.intel.com> <20070510194233.335004b7@griffin.suse.cz> <46437DC8.2060805@linux.intel.com> <20070510212355.6c13cde8@griffin.suse.cz> <1ba2fa240705101524x2676a09eyeff3b71ed2542478@mail.gmail.com> <20070511001212.GB6971@tuxdriver.com> <464424A7.2040301@warmcat.com> <46443266.4060102@garzik.org>
In-Reply-To: <46443266.4060102@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jeff Garzik wrote:
> Andy Green wrote:
>> Sexy-sounding "hw offloading" is a very different thing to migrating off
>> open code and putting it in vendor-specific closed source firmware.  The
>> firmware is just code like any other, for an embedded ARM7 or similar,
>> except that it is customized for a specific vendor hardware
>> implementation and you will never see the sources.  What I understand is
>> being talked about (maybe unlike the scan stuff this actually is in
>> hardware, but I doubt it) is ignoring code in the stack and instead
>> implementing pretty much the same code privately, to compile to a binary
>> blob you can't see source for or even reverse according to its license.
>>  That is a lot less romantic than mysterious hardware just waiting to be
>> used.
> 
> OTOH, this is all vague, paranoid hand-waving since I'm guessing you
> don't know the internals of the Intel hardware.

It's nice that you took the time to read and respond to my points in a
way that moved the debate on.  What is vague?  There definitely is
closed-source firmware for this product, you can download it yourself

http://intellinuxwireless.org/iwlwifi/downloads/iwlwifi-ucode-2.14.1.tgz

and read the license: and the code for it is produced as I describe
above. As for the specific case of the rate list, James knows if that is
firmware and I am sure he will tell us if it is genuine hardware support.

> We'll see what happens when Intel posts code to specify a different rate
> control algorithm.

What will you see?  You won't be seeing the firmware side of it except
in binary.

-Andy
