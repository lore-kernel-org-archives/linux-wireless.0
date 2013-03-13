Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:60319 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab3CMXTJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 19:19:09 -0400
Received: by mail-oa0-f50.google.com with SMTP id l20so1684221oag.23
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2013 16:19:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1363171283.32099.343.camel@i7.infradead.org>
References: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
	<1363171283.32099.343.camel@i7.infradead.org>
Date: Thu, 14 Mar 2013 00:19:08 +0100
Message-ID: <CACna6ryEBFqg1ORRcbob+FWcFGiMt9fOfQAkAov9wmoR8M4Fxw@mail.gmail.com> (sfid-20130314_001919_859618_CBCCFDE4)
Subject: Re: [PATCH 00/13] b43: implement basic TX power mgmt
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/13 David Woodhouse <dwmw2@infradead.org>:
> On Thu, 2013-03-07 at 16:47 +0100, Rafał Miłecki wrote:
>> After spotting a lot of N-PHY-similar functions in
>> BCM4331 dump of MMIO ops - split into names parts
>> I was able to finally improve HT-PHY code.
>>
>> It now sets TX basically, I can finally talk with devices that are few
>> meters away, not just few centimetres. It's a little patch bomb, sorry
>> for that, but I wasn't sure if my code is correct until it was complete
>> and started working.
>
> If you have a git tree I can pull this from, I'd be happy to give it
> some testing...

You can try wireless-testing:
http://git.kernel.org/cgit/linux/kernel/git/linville/wireless-testing.git

-- 
Rafał
