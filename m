Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50649 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751095AbZGaSe4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 14:34:56 -0400
Message-ID: <4A73394D.1070200@gmx.de>
Date: Fri, 31 Jul 2009 20:34:53 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k: monitor mode needs channel change
References: <4A72113F.8000604@gmx.de> <b6c5339f0907301505yde9e457k4ddc87b1c9120a84@mail.gmail.com>
In-Reply-To: <b6c5339f0907301505yde9e457k4ddc87b1c9120a84@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/31/2009 12:05 AM, Bob Copeland wrote:
> On Thu, Jul 30, 2009 at 5:31 PM, Joerg Albert<jal2@gmx.de> wrote:
>> I currently need an extra trigger by changing the channel after
>> "ifconfig up" to see any output in monitor mode from ath5k, e.g.
> 
> Does this (accidentally) fix it by chance?
> 
> http://patchwork.kernel.org/patch/38165/
> 
> It reloads the filters at ifup time.

No, unfortunately this patch was already part of my ath5k.
I'll try to add some printk.

