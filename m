Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:62660 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab0CVFWu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 01:22:50 -0400
From: Karsten Keil <isdn@linux-pingi.de>
Reply-To: isdn@linux-pingi.de
To: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [RFC PATCH 10/19] pcmcia: dev_node removal (drivers with updated printk call)
Date: Mon, 22 Mar 2010 06:22:28 +0100
Cc: linux-pcmcia@lists.infradead.org,
	Harald Welte <laforge@gnumonks.org>, linux-ide@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-usb@vger.kernel.org
References: <20100321230617.GA24791@comet.dominikbrodowski.net> <1269212857-25364-10-git-send-email-linux@dominikbrodowski.net>
In-Reply-To: <1269212857-25364-10-git-send-email-linux@dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003220622.28507.isdn@linux-pingi.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Montag, 22. März 2010 00:07:28 Dominik Brodowski wrote:
> As a second step, remove any usage of dev_node_t from drivers which
> only wrote to this typedef/struct, except one printk() which can
> easily be replaced by a dev_info()/dev_warn() call.
> 
> CC: Harald Welte <laforge@gnumonks.org>
> CC: linux-ide@vger.kernel.org
> CC: Karsten Keil <isdn@linux-pingi.de>
> CC: linux-wireless@vger.kernel.org
> CC: netdev@vger.kernel.org
> CC: linux-usb@vger.kernel.org
> Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

Acked-by: Karsten Keil  <isdn@linux-pingi.de>

Thanks.
