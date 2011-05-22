Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1082 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780Ab1EVMr0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 08:47:26 -0400
Message-ID: <4DD905CC.8040407@broadcom.com> (sfid-20110522_144731_971529_09D82935)
Date: Sun, 22 May 2011 14:47:08 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Dan Carpenter" <error27@gmail.com>
Subject: Re: [RFC] lib: crc8: add new library module providing crc8
 algorithm
References: <1306010973-5625-1-git-send-email-arend@broadcom.com>
 <20110522122325.108b1c86@lxorguk.ukuu.org.uk>
In-Reply-To: <20110522122325.108b1c86@lxorguk.ukuu.org.uk>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/22/2011 01:23 PM, Alan Cox wrote:
> On Sat, 21 May 2011 22:49:33 +0200
> "Arend van Spriel"<arend@broadcom.com>  wrote:
>
>> The brcm80211 driver in staging tree uses a crc8 function. Based on
>> feedback from John Linville to move this to lib directory, the linux
>> source has been searched. Although there is currently only one other
>> kernel driver using this algorithm (ie. drivers/ssb) we are providing
>> this as a library function for others to use.
> Can we find a better name for it - there seem to be lots of CRC8 variants
> that are different - eg bit direction and it's going to be confusing to
> just call it 'crc8'

No problem. I just had a look at the lib directory and noticed the crc7 
function and module is called crc7. I can imagine there are enough 
variants of that as well. Another variation is probably the polynomial 
used. Not sure how to factor in bit direction and polynomial into the name.

suggestions from my thumb:
- rnw_crc8: refers to Ross N. Williams who wrote the paper used for 
implementing this function.
- painless_crc8: refers to title of the paper "A Painless Guide to CRC 
Error Detection Algorithms".
- brcm_crc8: indicates where the function came from.

Other suggestions are welcome.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


