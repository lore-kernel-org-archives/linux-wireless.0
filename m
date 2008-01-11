Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:24049 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759505AbYAKPRH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 10:17:07 -0500
Received: by ug-out-1314.google.com with SMTP id z38so480283ugc.16
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2008 07:17:06 -0800 (PST)
Message-ID: <478786FD.1020603@gmail.com> (sfid-20080111_151713_164306_19591FA5)
Date: Fri, 11 Jan 2008 16:10:53 +0100
From: Ronald <ronald645@gmail.com>
Reply-To: ronald645@gmail.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Bcm4311 shuts down on closing lid (intended?)
References: <47866FE6.4010100@gmail.com>	 (sfid-20080110_192630_077617_B3331316) <1200052973.3861.167.camel@johannes.berg>	 <47876C32.8090004@gmail.com> (sfid-20080111_132311_007072_430845CE) <1200062822.3861.169.camel@johannes.berg>
In-Reply-To: <1200062822.3861.169.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> So that means the other drivers (bcm43xx and ndiswrapper) provided 
>> enough signal strength to keep the wireless going even when it was 
>> horizontal?
> 
> Hm, ok, that is a bit odd, I wouldn't have expected bcm43xx to do that.
> Are you sure you're testing in the same place with the same distance to
> the AP etc?
> 
I'm not quite sure anymore about the bcm43xx behaviour. But I'm sure of 
ndiswrapper. Need to test bcm43xx?

>> P.S. I want to add my wireless card to the list (of working cards) (it's 
>> not dell). How can I do this?
> 
> You can't edit the global list, only the per-driver list, for that you
> need to sign up to the wiki and log in.
> 
> johannes
