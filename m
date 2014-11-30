Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:57571 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbaK3IjI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Nov 2014 03:39:08 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: nick <xerofoify@gmail.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<wil6210@qca.qualcomm.com>, <netdev@vger.kernel.org>
Subject: Re: Question about function. wil_vring_alloc_skb in txrx.c
Date: Sun, 30 Nov 2014 10:39:03 +0200
Message-ID: <8489393.vIdH6vj4qd@lx-wigig-72> (sfid-20141130_093911_854404_66786781)
In-Reply-To: <547A5554.3010900@gmail.com>
References: <547A5554.3010900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday, November 29, 2014 06:23:00 PM nick wrote:
> Greetings Vladimr,John and others,
> I am wondering about the TODO in the function in my message at it seems to be no longer needed due to us reserving headroom for the skb packet used in this function. The other reason I can see that this is needed is if we need to 
> align the sk_buff for performance or hardware alignment reasons. If that is the case, would someone we willing to
> explain to me how the maintainers would like me to align the sk_buff packet used in the function, wil_vring_alloc_skb.
Hi Nick,
ignore this TODO, I'll remove it. I was not sure what is better for the hardware, now I know there is no hardware
limitation.

Thanks, Vladimir
