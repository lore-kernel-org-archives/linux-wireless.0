Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3098 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbYBURCc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 12:02:32 -0500
Date: Thu, 21 Feb 2008 11:31:34 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Ahmed Ammar <b33fc0d3@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: b43 (H/W 4306 Rev. 03)
Message-ID: <20080221163134.GF3094@tuxdriver.com> (sfid-20080221_170236_648894_08B04C60)
References: <84ac67910802210444q4da4f02bo2d172493ef2c7158@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <84ac67910802210444q4da4f02bo2d172493ef2c7158@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 21, 2008 at 12:44:15PM +0000, Ahmed Ammar wrote:
> As per my talk with st3 #bcm-users I have decided you e-mail you with
> the details of my problem. I have this card:
> 
> 02:07.0 Network controller: Broadcom Corporation BCM4306 802.11b/g
> Wireless LAN Controller (rev 03)
> 
> And whatever I do I can not get it to associate, I have tried with and
> without encryption and below are two pastes of dmesg with and without
> hwcrypto. I am not alone in this I have other people who have the same
> problem and have to use this patch to get the card working on
> b43legacy instead (http://url2cut.com?pwI)

> Broadcom 43xx driver loaded [ Features: PL, Firmware-ID: FW13 ]

I wonder if you could try using the firmware from here instead (aka FW11):

	http://downloads.openwrt.org/sources/broadcom-wl-4.80.53.0.tar.bz2

Does that improve the situation for you?

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
