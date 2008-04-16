Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from h-84.19.172.232.keyweb.de ([84.19.172.232]:52286 "EHLO
	mail.paterna.nl" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbYDPKp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 06:45:27 -0400
Received: from localhost (unknown [84.19.172.232])
	by mail.paterna.nl (Postfix) with ESMTP id EE887B40F05
	for <linux-wireless@vger.kernel.org>; Wed, 16 Apr 2008 10:39:21 +0000 (UTC)
Received: from mail.paterna.nl ([84.19.172.232])
 by localhost (pat.virsys.biz [84.19.172.232]) (amavisd-maia, port 10024)
 with ESMTP id 53681-05 for <linux-wireless@vger.kernel.org>;
 Wed, 16 Apr 2008 10:39:21 +0000 (UTC)
Received: from [131.114.248.50] (unknown [131.114.248.50])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: ordex@ritirata.org)
	by mail.paterna.nl (Postfix) with ESMTP id 8F524B40EE7
	for <linux-wireless@vger.kernel.org>; Wed, 16 Apr 2008 10:39:21 +0000 (UTC)
Message-ID: <4805D72A.1080508@ritirata.org> (sfid-20080416_114534_090125_C3DD311D)
Date: Wed, 16 Apr 2008 12:38:34 +0200
From: Antonio Quartulli <ordex@ritirata.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-04-15
References: <20080415193857.GA16625@tuxdriver.com> <20080415.192042.119702071.davem@davemloft.net>
In-Reply-To: <20080415.192042.119702071.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

why is the compat-wireless snapshot dated only 8th April? :/

David Miller ha scritto:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Tue, 15 Apr 2008 15:38:57 -0400
> 
>> This set looks bigger than it really is...three of the patches deal
>> with a subtle API change for the SSB bus to do DMA correctly on
>> architectures with complex DMA requirements.  The changes in those
>> patches amount to applying the same one-line change in dozens of
>> places across three drivers (b44, b43, and b43legacy).
>>
>> Also included are a number of MAINTAINERS updates.  I guess everyone
>> forgets about these until the release nears.
>>
>> Finally there are a few minor fixes, like the rfkill fix to only toggle
>> state for the correct device type rather than all devices on a system,
>> the rtl8187 priv->vif fix, the gelic IE overrun fix, and the mac80211
>> fix to limit log SPAM.
>>
>> Please let me know if there are problems!  Hopefully this will be the
>> last round before 2.6.25...(famous last words...)
> 
> Pulled, thanks John.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Antonio Quartulli,
  Student of Computer Science at University of Pisa
  Web: www.ritirata.org/ordex
