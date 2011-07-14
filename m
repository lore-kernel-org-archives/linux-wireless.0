Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44445 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab1GNKfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 06:35:30 -0400
Message-ID: <4E1EC66B.9050705@qca.qualcomm.com> (sfid-20110714_123534_049138_B1E6F6E2)
Date: Thu, 14 Jul 2011 13:35:23 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <devel@linuxdriverproject.org>,
	<gregkh@suse.de>
Subject: Re: [PATCH 00/24] ath6kl cleaned up driver
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6> <20110714100612.GW18655@shale.localdomain>
In-Reply-To: <20110714100612.GW18655@shale.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/14/2011 01:06 PM, Dan Carpenter wrote:
> On Wed, Jul 13, 2011 at 04:32:44AM +0300, Kalle Valo wrote:
>> The most important tasks left are:
>>
>> o proper review of locking (currently 13 spin locks and one semaphore)
> 
> For example the DMA bounce buffer should probably be protected by
> a lock so dueling threads don't corrupt it.

Thanks, I added this to the todo list.

http://wireless.kernel.org/en/users/Drivers/ath6kl/todo

Kalle
