Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:6055 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbXJZOzF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 10:55:05 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Remove pointless casts from void pointers,
Date: Fri, 26 Oct 2007 16:55:07 +0200
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
	akpm@linux-foundation.org, rmk@arm.linux.org.uk,
	kernel@wantstofly.org, tony.luck@intel.com,
	jwboyer@linux.vnet.ibm.com, benh@kernel.crashing.org,
	paulus@samba.org, dmitry.torokhov@gmail.com,
	netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-serial@vger.kernel.org, bryan.wu@analog.com,
	adaplas@gmail.com
References: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
In-Reply-To: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710261655.07757.hs4233@mail.mn-solutions.de> (sfid-20071026_155515_453219_1AE73D1C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  drivers/net/wireless/libertas/if_cs.c      |    2 +-

ACK
