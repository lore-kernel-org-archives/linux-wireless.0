Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57438 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827Ab0K2QEw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 11:04:52 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 29 Nov 2010 08:04:38 -0800
Date: Mon, 29 Nov 2010 21:34:26 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 1/3] ath9k: Disable SWBA interrupt on remove_interface
Message-ID: <20101129160415.GA3593@vmraj-lnx.users.atheros.com>
References: <1290794073-5309-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1290794073-5309-1-git-send-email-rmanoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 26, 2010 at 11:24:31PM +0530, Rajkumar Manoharan wrote:
> while removing beaconing mode interface, SWBA interrupt
> was never disabled when there are no other beaconing interfaces.
> 
Race condition needs to be taken care. will send v2 patch.

--
Rajkumar
