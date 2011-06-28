Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60218 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab1F1Ukd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 16:40:33 -0400
Message-ID: <4E0A3C36.8040305@candelatech.com> (sfid-20110628_224038_156750_2CA71AFA)
Date: Tue, 28 Jun 2011 13:40:22 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Michel Alexandre Salim <salimma@fedoraproject.org>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: Re: [ath9k-devel] [PATCH] ath9k: add module option for disabling
 11n functionality
References: <4E0A2F8A.8010102@fedoraproject.org> <4E0A30CD.9030006@candelatech.com> <BANLkTimRc-SzfeYhiKJ5g9pn3tuUzJM_DQ@mail.gmail.com>
In-Reply-To: <BANLkTimRc-SzfeYhiKJ5g9pn3tuUzJM_DQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/28/2011 01:06 PM, Luis R. Rodriguez wrote:
> On Tue, Jun 28, 2011 at 12:51 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 06/28/2011 12:46 PM, Michel Alexandre Salim wrote:
>>> Some wireless base stations implement 802.11n mode in ways that
>>> open-source drivers cannot handle properly, resulting in very unstable
>>> connections. This patch introduces an '11n_disable' option to the ath9k
>>> driver, similar to the same option for the iwlagn driver.
>>>
>>> Tested at the internal wireless network of www.cs.fau.de, where 802.11n
>>> currently only works reliably with Windows clients.
>>
>> Would be lovely if this could be per VIF, and settable through something
>> dynamic, even if just debugfs or similar....
>
> WTF. Are such APs WFA certified? Can you provide more details as to
> why there is a mode that "open-source drivers cannot handle properly".

I'd like the feature for testing purposes (use ath9k to act like
just an a/b/g NIC).  No idea about whatever the original poster
is using.

Thanks,
Ben

>
>    Luis


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

