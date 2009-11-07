Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:43665 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbZKGIg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 03:36:26 -0500
Received: from [192.168.0.26] (really [97.103.55.168])
          by cdptpa-omta02.mail.rr.com with ESMTP
          id <20091107083630766.YTDA6968@cdptpa-omta02.mail.rr.com>
          for <linux-wireless@vger.kernel.org>;
          Sat, 7 Nov 2009 08:36:30 +0000
Subject: [PATCH] This adds support for the wifi led on the Compaq
 CQ60-206US.
From: David Dreggors <ddreggors@cfl.rr.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Nov 2009 03:36:29 -0500
Message-ID: <1257582989.23806.85.camel@mobile-tek.home>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
         drivers/net/wireless/ath/ath5k/led.c |    2 ++
         1 files changed, 2 insertions(+), 0 deletions(-)
        
        diff --git a/drivers/net/wireless/ath/ath5k/led.c
        b/drivers/net/wireless/ath/ath5k/led.c
        index 7ce98bd..ce6ce0a 100644
        --- a/drivers/net/wireless/ath/ath5k/led.c
        +++ b/drivers/net/wireless/ath/ath5k/led.c
        @@ -57,6 +57,8 @@ static const struct pci_device_id
        ath5k_led_devices[] = {
                { PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5211),
        ATH_LED(0, 0) },
                /* HP Compaq nc6xx, nc4000, nx6000 */
                { ATH_SDEVICE(PCI_VENDOR_ID_COMPAQ, PCI_ANY_ID),
        ATH_LED(1, 1) },
        +       /* HP Compaq CQ60-206US */
        +       { ATH_SDEVICE(PCI_VENDOR_ID_HP, 0x137a), ATH_LED(3,
        1) },
                /* Acer Aspire One A150 (maximlevitsky@gmail.com) */
                { ATH_SDEVICE(PCI_VENDOR_ID_FOXCONN, 0xe008), ATH_LED(3,
        0) },
                /* Acer Aspire One AO531h AO751h
        (keng-yu.lin@canonical.com) */
        -- 
        1.6.4.4

