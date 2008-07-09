Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:31850 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751470AbYGISeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 14:34:12 -0400
Message-ID: <48750494.8010802@sbcglobal.net> (sfid-20080709_203415_902309_431735E2)
Date: Wed, 09 Jul 2008 11:33:56 -0700
From: Bryan Batten <BryanBatten@sbcglobal.net>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	linville@tuxdriver.com, rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] [PATCH] rt2x00: Fix NULL pointer error in	adhoc/master
 mode
References: <200807051511.57995.IvDoorn@gmail.com>	<200807052042.47008.IvDoorn@gmail.com>	<4874FC95.3050904@sbcglobal.net> <200807092029.10007.IvDoorn@gmail.com>
In-Reply-To: <200807092029.10007.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn wrote:
...
> Yes, but if you look again you see that the legacy driver does
> define it, and even includes the description of bits 9 -> 19 And
> the legacy driver source code has always been more reliable then 
> the datasheet, so I would put my money on the code. ;)

I know. But I suspect that in this case, the datasheet just *may* be 
correct.

>> Would it be possible to verify with Ralink that this is not a
>> typo in the RT2500 datasheet?
> 
> I'll see what I can find out.
> 

Thanks,
-- 
Bryan
-
"Beyond the point of no return, there's no going back."

Narration to "Mars Rising" on the Science Channel
