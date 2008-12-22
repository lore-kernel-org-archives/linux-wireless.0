Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:51062 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbYLVVhI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 16:37:08 -0500
Message-ID: <4950087E.3080505@gmail.com> (sfid-20081222_223714_279538_933F97E7)
Date: Mon, 22 Dec 2008 22:37:02 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Soeren Sonnenburg <kernel@nn7.de>, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: ath5k_pci: gain calibration timeout / unable to reset hardware
 -11
References: <1229923913.3886.7.camel@localhost> <20081222125819.7353d172.akpm@linux-foundation.org>
In-Reply-To: <20081222125819.7353d172.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/22/2008 09:58 PM, Andrew Morton wrote:
> (cc linux-wireless)
> 
> On Mon, 22 Dec 2008 06:31:53 +0100
> Soeren Sonnenburg <kernel@nn7.de> wrote:
> 
>> Hi,
>>
>> I was using the ath5k_pci driver on a macbook pro 1,1 and it is working
>> for some time but then suddenly messages like the ones below appear and
>> I have to *turn off* the machine to get it back working (even booting to
>> osx is not sufficient - osx won't have network when things go wrong as
>> they do after a couple of hours). Note that this happens with both
>> 2.6.27 and .28.

Does the _HW lockup_ happen even with 2.6.28? The lockup should be gone there
(with the messages still present).
