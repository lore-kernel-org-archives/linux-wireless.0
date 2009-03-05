Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:37795 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868AbZCEVbm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 16:31:42 -0500
Message-ID: <49B044BA.8060908@lwfinger.net> (sfid-20090305_223145_771995_87750FC8)
Date: Thu, 05 Mar 2009 15:31:38 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 7/7] p54: initial SoftLED support
References: <200903052133.45893.chunkeey@web.de>
In-Reply-To: <200903052133.45893.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> This patch adds SoftLED support for all p54 devices.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>

This one causes a kernel panic with my p54usb device - a DW1450.

I'll try and see if I can discover more details, but I have none at the moment.
The only thing I saw was that both LED's blinked briefly. Normally, only one is
continuously on.

The other 6 patches are not causing any problems.

Larry
