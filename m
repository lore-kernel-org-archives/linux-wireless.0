Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59066 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaBXUpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 15:45:16 -0500
Date: Mon, 24 Feb 2014 15:37:58 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH 0/3 v2] Enable ACS Support
Message-ID: <20140224203757.GJ24810@tuxdriver.com> (sfid-20140224_214522_662111_B8116FAE)
References: <20140219124740.GA5341@markyou.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140219124740.GA5341@markyou.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 19, 2014 at 06:17:41PM +0530, Yogesh Ashok Powar wrote:
> With these patches, mwl8k will able to use
> automatic channel selection feature from Hostapd.
> 
> Yogesh Ashok Powar (3):
>   mwl8k: Adding support to access BBP registers
>   mwl8k: Implement sw_scan start/stop cbs
>   mwl8k: Adding support to gather survey per channel
> 
>  drivers/net/wireless/mwl8k.c | 195 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 189 insertions(+), 6 deletions(-)

I had build failures with these patches applied...?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
