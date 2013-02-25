Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:20188 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758627Ab3BYQS5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 11:18:57 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Trevor Cullen <tcc@innovelec.co.uk>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Subject: Re: AR9374 Rev 1.3/RevB USB Linux drivers?
References: <00d301ce1369$d9ec9f20$8dc5dd60$@innovelec.co.uk>
Date: Mon, 25 Feb 2013 18:18:50 +0200
In-Reply-To: <00d301ce1369$d9ec9f20$8dc5dd60$@innovelec.co.uk> (Trevor
	Cullen's message of "Mon, 25 Feb 2013 15:07:36 +0000")
Message-ID: <871uc4l639.fsf@kamboji.qca.qualcomm.com> (sfid-20130225_171901_845075_B8CAE6CF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trevor Cullen <tcc@innovelec.co.uk> writes:

> We got the open source driver from QCA via their support portal -
> ath6kl_usb_3.2.1_RC

This is an internal (forked) version of the driver. For getting help on
that one you need to use official QCA support channels.

> Rev B is the correct chip designation for the AR9374 silicon (that is the
> same as hw1.3) - so AR9374-BL3D is the full chip number
>
> We're getting mixed messages about support for this version in the open
> community.

That's because the internal driver is different from what's in upstream
Linux kernel or compat-wireless.

-- 
Kalle Valo
