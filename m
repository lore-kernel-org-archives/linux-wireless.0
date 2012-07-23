Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39191 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab2GWIvH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 04:51:07 -0400
Message-ID: <500D106E.50500@openwrt.org> (sfid-20120723_105111_471807_B6A25B44)
Date: Mon, 23 Jul 2012 10:50:54 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: linville@tuxdriver.com, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH] ath: Remove EEPROM dump functions
References: <20492.53472.318382.889445@gargle.gargle.HOWL>
In-Reply-To: <20492.53472.318382.889445@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-07-23 6:19 AM, Sujith Manoharan wrote:
> This can be done from userspace.
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
I think we should keep this code until we have a proper user space
replacement, I've been using it for debugging a number of times.
The qca-swiss-army-knife patch that you posted is missing quite a bit of
stuff (AR9003 support, HTC support).

- Felix
