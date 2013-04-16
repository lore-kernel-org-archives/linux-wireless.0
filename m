Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755152Ab3DPK2W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 06:28:22 -0400
Date: Tue, 16 Apr 2013 12:29:11 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: minimumlaw@rambler.ru
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] rt2x00: Fix transmit power troubles on some Ralink
 RT30xx cards
Message-ID: <20130416102910.GA1163@redhat.com> (sfid-20130416_122826_407009_94FAA0E9)
References: <1365996575-18989-1-git-send-email-minimumlaw@rambler.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1365996575-18989-1-git-send-email-minimumlaw@rambler.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 15, 2013 at 07:29:35AM +0400, minimumlaw@rambler.ru wrote:
> From: "Alex A. Mihaylov" <minimumlaw@rambler.ru>
> 
> Some cards on Ralink RT30xx chipset not have correctly TX_MIXER_GAIN
> value in them EEPROM/EFUSE. In this case, we must use default value,
> but always used EEPROM/EFUSE value. As result we have tranmitt power
> range from -10dBm to +6dBm instead 0dBm to +16dBm.
> 
> Correctly value in EEPROM/EFUSE is one or more for RT3070 and two or
> more for other RT30xx chips.
> 
> Tested on Canyon CNP-WF518N1 usb Wi-Fi dongle and Jorjin WN8020 usb
> embedded Wi-Fi module.
> 
> Signed-off-by: Alex A. Mihaylov <minimumlaw@rambler.ru>
> Cc: stable@vger.kernel.org

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

