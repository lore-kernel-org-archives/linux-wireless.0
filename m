Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:38702 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757101AbXEWQoM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2007 12:44:12 -0400
Message-ID: <46545AC0.4070301@linux.intel.com>
Date: Wed, 23 May 2007 08:16:16 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH v3]  Add iwlwifi wireless drivers
References: <464B7B7C.5080800@linux.intel.com> <465365B3.4090408@linux.intel.com> <4653939B.9020904@garzik.org>
In-Reply-To: <4653939B.9020904@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jeff Garzik wrote:
> James Ketrenos wrote:
>> An updated full patch (v3) to add the driver is available at:
>>         
>> http://intellinuxwireless.org/iwlwifi/0001-v3-Add-iwlwifi-wireless-drivers.patch 
> 
> 
> Quick review attached.
> 
>     Jeff

Thanks for the review.  

Hopefully once in wireless-dev, we (more than just me, myself, and I) can work to get these knocked off in iterative small commits vs. having to paste a monolithic driver add patch that makes git-bisect near useless.  Some of your review comments impact code which can have significant ripple effects -- I would like to be able to manage those changes here vs. solely with the iwlwifi community of users.

James
