Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:34943 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932434AbcJMN4v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 09:56:51 -0400
MIME-Version: 1.0
In-Reply-To: <1476358075.1999.5.camel@tiscali.nl>
References: <1476349269.3880.18.camel@coelho.fi> <20161013102155.14547-1-luca@coelho.fi>
 <1476358075.1999.5.camel@tiscali.nl>
From: Chris Rorvick <chris@rorvick.com>
Date: Thu, 13 Oct 2016 08:56:38 -0500
Message-ID: <CAEUsAPaqyxA1=3ktisBO3Vrw9ygi7PSrk32Rw+iyHVe_WB1oyg@mail.gmail.com> (sfid-20161013_155710_940401_686005F6)
Subject: Re: [PATCH] iwlwifi: pcie: fix SPLC structure parsing
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        emmanuel.grumbach@intel.com, johannes@sipsolutions.net,
        kvalo@codeaurora.org, oren.givon@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luca,

> On Thu, 2016-10-13 at 13:21 +0300, Luca Coelho wrote:
> Could you please give this a spin? I have tested it with some handmade
> ACPI tables in QEMU and it seems to work fine now.

Tested-by: Chris Rorvick <chris@rorvick.com>

I think the debug output looks as expected, see below for the first 20
lines or so.  And, more importantly, everything seems to be working!
:-)

Thanks!

Chris

==========

iwlwifi 0000:3a:00.0: L1 Enabled - LTR Disabled
iwlwifi: module verification failed: signature and/or required key
missing - tainting kernel
Intel(R) Wireless WiFi driver for Linux
Copyright(c) 2003- 2015 Intel Corporation
iwlwifi 0000:3a:00.0: U iwl_pcie_prepare_card_hw iwl_trans_prepare_card_hw enter
iwlwifi 0000:3a:00.0: U iwl_pcie_set_hw_ready hardware ready
iwlwifi 0000:3a:00.0: U iwl_request_firmware attempting to load
firmware 'iwlwifi-8000C-24.ucode'
iwlwifi 0000:3a:00.0: Direct firmware load for iwlwifi-8000C-24.ucode
failed with error -2
iwlwifi 0000:3a:00.0: U iwl_request_firmware attempting to load
firmware 'iwlwifi-8000C-23.ucode'
iwlwifi 0000:3a:00.0: Direct firmware load for iwlwifi-8000C-23.ucode
failed with error -2
iwlwifi 0000:3a:00.0: U iwl_request_firmware attempting to load
firmware 'iwlwifi-8000C-22.ucode'
iwlwifi 0000:3a:00.0: Direct firmware load for iwlwifi-8000C-22.ucode
failed with error -2
iwlwifi 0000:3a:00.0: U iwl_request_firmware attempting to load
firmware 'iwlwifi-8000C-21.ucode'
iwlwifi 0000:3a:00.0: U iwl_req_fw_callback Loaded firmware file
'iwlwifi-8000C-21.ucode' (2394060 bytes).
iwlwifi 0000:3a:00.0: U iwl_parse_tlv_firmware unknown TLV: 48
iwlwifi 0000:3a:00.0: U iwl_parse_tlv_firmware GSCAN is supported but
capabilities TLV is unavailable
iwlwifi 0000:3a:00.0: U splc_get_pwr_limit No element for the WiFi
domain returned by the SPLC method.
iwlwifi 0000:3a:00.0: U set_dflt_pwr_limit Default power limit set to 0
iwlwifi 0000:3a:00.0: loaded firmware version 21.302800.0 op_mode iwlmvm
iwlwifi 0000:3a:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=0x208
