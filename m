Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f49.google.com ([209.85.213.49]:52302 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933152Ab3BSS2R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 13:28:17 -0500
Message-ID: <5123C43D.2020602@lwfinger.net> (sfid-20130219_192829_175186_AF258F03)
Date: Tue, 19 Feb 2013 12:28:13 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: David.Laight@ACULAB.COM, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	bittorf@bluebottle.com, stable@vger.kernel.org
Subject: Re: [PATCH] b43: Increase number of RX DMA slots
References: <20130219.005206.397289032011003833.davem@davemloft.net> <AE90C24D6B3A694183C094C60CF0A2F6026B7152@saturn3.aculab.com> <5123BCFF.5090408@lwfinger.net> <20130219.131553.787630407148880340.davem@davemloft.net>
In-Reply-To: <20130219.131553.787630407148880340.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/19/2013 12:15 PM, David Miller wrote:

> I understand your constraints, but this is a trivially remotely
> DoS'able condition even on slow CPU atom laptops.
>
> Send an "expansive" full sized frame followed by 300 or so 64-byte UDP
> packets --> instant hang.

Thanks for the suggestion for a test. I think the reset solution should survive 
with only some packet loss, but we will find out.

Larry


