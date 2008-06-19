Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:29553 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbYFSR13 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 13:27:29 -0400
Received: by ug-out-1314.google.com with SMTP id h2so1008935ugf.16
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jun 2008 10:27:24 -0700 (PDT)
Message-ID: <485A96F4.8070402@gmail.com> (sfid-20080619_192732_155730_6567A66E)
Date: Thu, 19 Jun 2008 18:27:16 +0100
MIME-Version: 1.0
To: Holger Schurig <hs4233@mail.mn-solutions.de>
CC: linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>,
	=?ISO-8859-1?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>,
	Bernhard Reiter <bernhard@intevation.de>
Subject: Re: 802.11 pccard, Agere 0x0156,0x0003?
References: <200806181715.20516.bernhard@intevation.de> <4859866A.1090300@gmail.com> <1213833799.5258.13.camel@dv> <200806190855.30791.hs4233@mail.mn-solutions.de>
In-Reply-To: <200806190855.30791.hs4233@mail.mn-solutions.de>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger Schurig wrote:
>>> There is a more recent version of the Agere driver
>>> available, which has been patched for 2.6 kernels. See
>>> <http://ubuntuforums.org/showthread.php?t=304217>
>> It's really a low hanging fruit.  The big thing that was
>> missing was firmware download for Agere, but Dave implemented
>> that.
> 
> You mean I can convert the sta_h2.h file from the above link to 
> some binary file and let orinoco+Dave's patches load that 
> firmware to the card?
> 
> I'm asking this because I also have a bunch of Hermes I and 
> Hermes II cards, which don't work with the Orinoco driver, but 
> with the "brought somewhat up to kernel 2.6" wlags_h2_718.tgz 
> driver from the above link. That driver works, but hurts the 
> eyes, and now has some problems with 2.6.25, e.g. at unloading 
> time.

The firmware download patches were written to work with Hermes I cards (to get the WPA capable firmware). IIRC, the Hermes II firmware download process is slightly different, so there'd need to be some tweaks before you could download to Hermes II cards.

Dave.
