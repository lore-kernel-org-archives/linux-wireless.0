Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:34883 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933454Ab1KCQ0y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 12:26:54 -0400
Message-ID: <4EB2C0CC.8030506@neratec.com> (sfid-20111103_172658_662764_11C4EC6C)
Date: Thu, 03 Nov 2011 17:26:52 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, nbd@openwrt.org
Subject: Re: [RFC v2 1/2] ath9k: add DFS radar pulse processing
References: <1320328553-28066-1-git-send-email-zefir.kurtisi@neratec.com>	<1320328553-28066-2-git-send-email-zefir.kurtisi@neratec.com> <CAD2nsn0PJqm3gCOiReUhJ3UGChWJZuy_pUnpu_rDUcshAcQWfQ@mail.gmail.com>
In-Reply-To: <CAD2nsn0PJqm3gCOiReUhJ3UGChWJZuy_pUnpu_rDUcshAcQWfQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/03/2011 04:56 PM, Mohammed Shafi wrote:
> On Thu, Nov 3, 2011 at 7:25 PM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>> [...]
>> +       switch (are->pulse_bw_info) {
>> +       case 0:
> 
> can we define some macro for this. thanks!
> 

Ok.
