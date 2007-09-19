Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:49605 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbXISN3K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 09:29:10 -0400
Message-ID: <46F12414.8000900@garzik.org>
Date: Wed, 19 Sep 2007 09:28:52 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: Please pull 'iwlwifi' branch of wireless-2.6
References: <20070918185040.GF4940@tuxdriver.com> <20070918.122258.82101397.davem@davemloft.net>
In-Reply-To: <20070918.122258.82101397.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller wrote:
> Jeff, if you have no objections I'll pull this into net-2.6.24


Given that there is now a large backlog of new drivers to review, I 
think the preferred course of action would be to queue them into -mm 
(via net-2.6.24) for wider review and testing, and then make sure they 
all get a thorough review+ACK before pushing upstream.

So far, its sounding like each review has turned up stuff that wants 
fixing before the drivers commented upon go upstream.

	Jeff


