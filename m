Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:11197 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450Ab2K0I20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 03:28:26 -0500
Date: Tue, 27 Nov 2012 13:58:35 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@venema.h4ckr.net>
Subject: Re: ath9k: Add concurrent WLAN and BT tx support for MCI based chips
Message-ID: <20121127082832.GA11602@hemis.qca.qualcomm.com> (sfid-20121127_092828_574218_A7024E52)
References: <20121126210337.GA27645@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20121126210337.GA27645@elgon.mountain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 27, 2012 at 12:03:37AM +0300, Dan Carpenter wrote:
> Hello Rajkumar Manoharan,
> 
> The patch db60428b1af1: "ath9k: Add concurrent WLAN and BT tx support
> for MCI based chips" from Oct 12, 2012, leads to the following
> warning:
> drivers/net/wireless/ath/ath9k/btcoex.c:414
> 	ath9k_hw_btcoex_set_concur_txprio()
> 		error: buffer overflow 'stomp_txprio' 4 <= 4
> 
Dan,

Thanks a lot. Is there a way to enable all checks while building smatch tool?

-Rajkumar
