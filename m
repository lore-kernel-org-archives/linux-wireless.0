Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43326 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab0EKTaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 15:30:13 -0400
Date: Tue, 11 May 2010 15:16:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Steve Tanner <steve.tanner@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@web.de>
Subject: Re: [PATCH] ar9170usb:add vendor and device ID for Qwest/Actiontec
 802AIN Wireless N USB Network Adapter
Message-ID: <20100511191654.GE2400@tuxdriver.com>
References: <AANLkTilNQBE7zwSaNjcaHG4YPD_zfK63aepIzccWIdSj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTilNQBE7zwSaNjcaHG4YPD_zfK63aepIzccWIdSj@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 11, 2010 at 02:19:35AM -0700, Steve Tanner wrote:
> * add support for the Qwest/Actiontec 802AIN Wireless N USB Network Adapter.
> 
> lsusb identifies the device as: "ID 1668:1200 Actiontec Electronics, Inc. [hex]"
> 
> usb_modeswitch package and appropriate rules are required to switch
> the device from "ID 0ace:20ff ZyDas"
> 
> Changes-licensed-under: GPL

Need a "Signed-off-by", please!

http://linux.yyz.us/patch-format.html

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
