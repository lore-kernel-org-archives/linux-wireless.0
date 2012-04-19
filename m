Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52390 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab2DSOJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 10:09:31 -0400
Received: by bkcik5 with SMTP id ik5so6399434bkc.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 07:09:30 -0700 (PDT)
Subject: Re: wlan0 not present
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
From: Dominik Feser <dominik.feser@googlemail.com>
In-Reply-To: <4F901224.1040508@sipsolutions.net>
Date: Thu, 19 Apr 2012 16:09:26 +0200
Cc: Dominik Feser <dominik.feser@googlemail.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Message-Id: <EA757D90-2CCE-48A1-AF35-7F65EB45F7EE@gmail.com> (sfid-20120419_160935_311365_A7BC3E05)
References: <2F08FF0B-5C29-4827-AA5F-B0F3847D0B83@gmail.com> <4B048FDE-C784-4401-9FEC-16F8CC0B8D59@gmail.com> <CANUX_P0FO-P6ZFow15shNpZg6Z8FAPP7AovJH=xUKPyVEMtoBw@mail.gmail.com> <FC927BD3-30FD-4DF2-A65C-5BE785FB72BC@gmail.com> <CANUX_P0dR93vJicsrnpxPmOZvaxBvaONHQiFXOTcaP1Ax0LAnQ@mail.gmail.com> <816C5F70-E340-46F9-8206-2B230A27F3AD@gmail.com> <CANUX_P3=ttVKdLYBfAdGRhmfDRbPruogw8Eo_d09on0ajdTqUw@mail.gmail.com> <5714877C-2465-4FD5-94A0-9D0806A803C4@gmail.com> <CANUX_P27GoLY2q9jmsWw9Rzn9posf3mCjDa98+q4JP=83wYthg@mail.gmail.com> <8FBCAE90-FAE9-430D-888E-F055091E6683@gmail.com> <CANUX_P1OxH7rmYWxizEaf2DnPSTK0npNtZ2Q9Rm5dksnmFKD8g@mail.gmail.com> <9D52D4AD-58DC-4896-97FC-7248E1FD2614@gmail.com> <CANUX_P1ZX_e+0qs4sa7vdAqHvOQjO6+9PiFhDbW8ybE4ax80gQ@mail.gmail.com> <8EE08C44-8618-45EC-B890-B5B12B661FB6@gmail.com> <CANUX_P0O0-6sOaN59V_RxLj_DbiTdNdwq0zze6B6vMe1hfQuqA@mail.gmail.com> <37926591-261D-4C3E-A1D9-4A8AB3364F5D@gmail.com> (sfid-20120419_152129_778732_024C8F79) <4F901224.1040508@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Finally, here is the output of dmesg after recompiling:

iwlwifi 0000:02:00.0: edd19e18
iwlwifi 0000:02:00.0: d55c1e18
iwlwifi 0000:02:00.0: d55c1ddc
iwlwifi 0000:02:00.0: PCI INT A disabled
Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
Copyright(c) 2003-2012 Intel Corporation
iwlwifi 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlwifi 0000:02:00.0: setting latency timer to 64
iwlwifi 0000:02:00.0: pci_resource_len = 0x00002000
iwlwifi 0000:02:00.0: pci_resource_base = f447c000
iwlwifi 0000:02:00.0: HW Revision ID = 0x34
iwlwifi 0000:02:00.0: irq 1277 (277) for MSI/MSI-X
iwlwifi 0000:02:00.0: U iwl_request_firmware d5b37d70
iwlwifi 0000:02:00.0: U iwl_request_firmware e09ebdd4
iwlwifi 0000:02:00.0: ee2afe18
iwlwifi 0000:02:00.0: U iwl_request_firmware ee2afdd4
iwlwifi 0000:02:00.0: cc93fe18
iwlwifi 0000:02:00.0: cc93fddc
iwlwifi 0000:02:00.0: U iwl_trans_pcie_rx_free cc93fd80
iwlwifi 0000:02:00.0: PCI INT A disabled


Am 19.04.2012 um 15:24 schrieb Johannes Berg:

> On 4/19/2012 6:20 AM, Dominik Feser wrote:
>> Ah ok, this is what I did several times now. After unpacking there is no .config file. After running the driver-select script and making the driver the first time the .config file appears.
>> Just then it seems to me that f I add the debug line to .config and remake this isn't recognized by the make...
> 
> You should modify config.mk, not .config
> 
> johannes

