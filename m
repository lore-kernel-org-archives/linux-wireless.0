Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:43038 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbZCPN3Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 09:29:24 -0400
Received: by nf-out-0910.google.com with SMTP id d21so962388nfb.21
        for <linux-wireless@vger.kernel.org>; Mon, 16 Mar 2009 06:29:21 -0700 (PDT)
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
Message-Id: <AF751E60-0D2E-400D-8650-032CCC1F90D9@icix.org> (sfid-20090316_142927_848559_7014CE18)
From: Antonio Marques <froz@icix.org>
To: Pat Erley <pat-lkml@erley.org>
In-Reply-To: <49BDB24D.3030508@erley.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: rt2x00 mesh support
Date: Mon, 16 Mar 2009 13:29:16 +0000
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org> <467E98EC-F5B1-4D79-914E-35E021125E37@icix.org> <594B4EB2-FE87-4756-B016-C83083EF415B@icix.org> <200903151445.01344.IvDoorn@gmail.com> <49BDB24D.3030508@erley.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mar 16, 2009, at 01:58 , Pat Erley wrote:
> I get identical behavior with the patch I'm about to RFC for ath9k  
> to enable
> mesh mode.  I just want to test that it works with my b43, rt61pci,  
> and
> rt2x00usb devices.  Of the 4, ONLY b43 enables beaconing for mesh  
> mode on
> interface up.  I suspect my ath5k one will exhibit similar  
> behavior.  I've
> reviewed the b43 code about 100 times during the writing of my patch  
> for ath9k
> and I can't spot what it's doing that's so different.
>
> Pat

I have also tested with ath5k which behaves correctly on interface up by
enabling beaconing. You might want to look at it too.

Antonio Marques
