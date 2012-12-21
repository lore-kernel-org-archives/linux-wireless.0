Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab2LUMAT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2012 07:00:19 -0500
From: Oliver Neukum <oneukum@suse.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Champion Chen <champion_chen@realsil.com.cn>
Subject: Re: [RFC/RFT] rtk_btusb: Bluetooth driver for Realtek RTL8723AE combo device
Date: Fri, 21 Dec 2012 13:00:44 +0100
Message-ID: <4349156.F5bN2NJJsz@linux-lqwf.site> (sfid-20121221_130025_884813_7ADEBA41)
In-Reply-To: <1356058371-17152-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1356058371-17152-1-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 20 December 2012 20:52:51 Larry Finger wrote:
> This new driver works with the RTL8723AE wireless/BT combo device. The
> corresponding firmware has been submitted to linux-firmware.

Very well. However, you cannot simply duplicate the whole code
of btusb without very good reason. The patch as is is absolutely
inacceptable.

	Regards
		Oliver

