Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:35831 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbZE2PlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2009 11:41:21 -0400
MIME-Version: 1.0
In-Reply-To: <20090529101834.GC3506@tuxdriver.com>
References: <20090529.014011.244789664.davem@davemloft.net>
	 <20090529101834.GC3506@tuxdriver.com>
Date: Fri, 29 May 2009 16:41:20 +0100
Message-ID: <3ace41890905290841h427f8a27v8772cb34503247c2@mail.gmail.com>
Subject: Re: [PATCH 4/10]: rtl8187: Remove pointless check in rtl8187_rx_cb().
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 29, 2009 at 11:18 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Fri, May 29, 2009 at 01:40:11AM -0700, David Miller wrote:
>>
>> First of all, it exposes the SKB list implementation.
>>
>> Second of all it's not needed.  If we get called here, we
>> successfully enqueued the URB with the linked SKB and
>> such a completion only gets called one time on such an
>> SKB.
>>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>
> ACK

ACK.

I'll give this a try when I rebuild the rtl8187 module on my box.

Hin-Tak
