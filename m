Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45100 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab2AENSV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 08:18:21 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMZO5C7+sfU-nfM+L8Z8aCzMd5HkTJTg5sconpOnxto=8DQLQ@mail.gmail.com>
References: <1325765663-7141-1-git-send-email-festevam@gmail.com>
	<CAL1gcdOrr41Br1Z-JCih6BGdxLmZ9ns+W-cVRxvd+guO2xC_zQ@mail.gmail.com>
	<CAOMZO5C7+sfU-nfM+L8Z8aCzMd5HkTJTg5sconpOnxto=8DQLQ@mail.gmail.com>
Date: Thu, 5 Jan 2012 11:18:20 -0200
Message-ID: <CAOMZO5BVVPnWtRSHbQGGo8ESU0nSzTY12B1MqqEMi3C-sVGvBA@mail.gmail.com> (sfid-20120105_141830_042397_D092E708)
Subject: Re: [PATCH] drivers: net: Fix dependency for EEPROM_93CX6
From: Fabio Estevam <festevam@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	davem@davemloft.net, linville@tuxdriver.com,
	Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 5, 2012 at 11:11 AM, Fabio Estevam <festevam@gmail.com> wrote:

...
> ,but still get the warnings in this case too.

I think the correct fix would be to add MISC_DEVICES into the 'depends
on' lines.

Do you agree?

Regards,

Fabio Estevam
