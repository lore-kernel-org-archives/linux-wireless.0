Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.142]:37124 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751165AbdBWU1Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 15:27:24 -0500
Message-ID: <1487881302.20481.3.camel@embedded.rocks> (sfid-20170223_212735_422616_35EB62EB)
Subject: brcmfmac: problem using  WPS with wpa_supplicant on BCM43362
From: =?ISO-8859-1?Q?J=F6rg?= Krause <joerg.krause@embedded.rocks>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Date: Thu, 23 Feb 2017 21:21:42 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am using Linux Kernel v4.9.9 and wpa_supplicant 2.6. When running
'wpa_cli wps_pin any', the following messages are printed:

"""
> wps_pin any         
[ 4011.779108] brcmfmac: brcmf_vif_set_mgmt_ie: vndr ie set error : -30
[ 4011.786190] brcmfmac: brcmf_config_ap_mgmt_ie: Set Beacon IE Failed
"""

.. and nothing happens. The data sheet for the BCM43362 states that the
module supports WPS.

Best regards,
Jörg Krause
