Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41944 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758497Ab1DZVtQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 17:49:16 -0400
Message-ID: <4DB73DD6.4010500@hauke-m.de> (sfid-20110426_234920_538517_44B5E230)
Date: Tue, 26 Apr 2011 23:49:10 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] compat-wireless: make patches apply again
References: <1303845431-972-1-git-send-email-hauke@hauke-m.de> <BANLkTi=9yc_9xH39LUD-NnZ3KX__VaSBaA@mail.gmail.com>
In-Reply-To: <BANLkTi=9yc_9xH39LUD-NnZ3KX__VaSBaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/26/2011 09:39 PM, Luis R. Rodriguez wrote:
> On Tue, Apr 26, 2011 at 12:17 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> 
> Thanks, sorry for not mentioning earlier I fixed this earlier today. I
> should have noted on IRC.
> 
>  Luis
Hi,

no problem. There is still a compile problem when using kernel < 2.6.32,
I will send a patch for this.

Hauke
