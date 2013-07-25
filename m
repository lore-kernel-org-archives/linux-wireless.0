Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50093 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab3GYPCD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jul 2013 11:02:03 -0400
Date: Thu, 25 Jul 2013 16:01:58 +0100
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2013-07-25
Message-ID: <20130725150156.GA21959@joana> (sfid-20130725_170226_721889_9F2554EA)
References: <20130725130552.GE9913@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130725130552.GE9913@joana>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

* Gustavo Padovan <gustavo@padovan.org> [2013-07-25 14:05:54 +0100]:

> Hi John,
> 
> A few fixes and devices ID additions for 3.11: 
> 
>  * There are 3 new ath3k device ids 
>  * Fixed stack memory usage in ath3k.
>  * Fixed the init process of BlueFRITZ! devices, they were failing to init
>    due to an unsupported command we sent. 
>  * Fixed wrong use of PTR_ERR in btusb code that was preventing intel devices
>    to work properly 
>  * Fixed race codition between hci_register_dev() and hci_dev_open() that
>    could cause a NULL pointer dereference.

Marcel just raised the comment that we need to add more information to
the BlueFRITZ! fixes so I'm steping back with it. So just ignore it for
now.

	Gustavo
