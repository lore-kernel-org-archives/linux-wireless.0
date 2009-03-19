Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:43999 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761094AbZCSUPn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 16:15:43 -0400
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Message-Id: <487FC78C-36A2-4353-ACB2-F924B09D231A@ing.unibs.it> (sfid-20090319_211551_107299_CC241A3F)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: Michael Buesch <mb@bu3sch.de>
In-Reply-To: <200903192110.08437.mb@bu3sch.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] b43: Mask PHY TX error interrupt, if not debugging
Date: Thu, 19 Mar 2009 21:15:40 +0100
References: <200903191927.21868.mb@bu3sch.de> <200903192013.44903.mb@bu3sch.de> <35D36C55-6CB3-443C-A916-D5771B68DD9A@ing.unibs.it> <200903192110.08437.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mar 19, 2009, at 9:10 PM, Michael Buesch wrote:

> On Thursday 19 March 2009 20:56:52 Francesco Gringoli wrote:
>> I would agree with you, but there is this bizarre issue with PHY
>> errors in monitoring mode that makes me thinking about what we call
>> PHY errors. I would say they are not only due to transmission, they
>> are general PHY errors, could they be? One last test I could try, is
>
> No the interrupt indicates a PHY TX error.
> This name is from the broadcom headers, so we can trust that it's  
> correct.
>
> As I said, I never saw the error with the proprietary firmware in  
> monitor mode.
> If you know a way how to trigger them, please tell me.
It should be pretty easy, if you can observe these errors in sta mode  
(for instance with the cool method you told me before), you should see  
the same errors also in monitor mode, that is what was happening with  
my two adapters mounted on the same pci raiser (one with four minipci  
slots, unfortunately broken as when I use it I see PHY errors).

Cheers,
-FG
