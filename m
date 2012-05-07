Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49152 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab2EGIXw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 04:23:52 -0400
Message-ID: <1336379032.18428.0.camel@sortiz-mobl> (sfid-20120507_102359_082592_2CCE9471)
Subject: Re: [PATCH 2/2] NFC: Select CRC_CCITT for SHDLC link layer of HCI
 based drivers
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 07 May 2012 10:23:52 +0200
In-Reply-To: <1336021968-19478-1-git-send-email-marcel@holtmann.org>
References: <1336021968-19478-1-git-send-email-marcel@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel,

On Thu, 2012-05-03 at 07:12 +0200, Marcel Holtmann wrote:
> The SHDLC link layer of HCI based drivers uses CRC-CCITT and thus
> needs to select that kernel option.
> 
> Otherwise it ends up with this linking error:
> 
> net/built-in.o: In function `nfc_shdlc_add_len_crc':
> net/nfc/hci/shdlc.c:113: undefined reference to `crc_ccitt'
> 
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.


