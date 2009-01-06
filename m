Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:57709 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZAFLMk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 06:12:40 -0500
Received: by an-out-0708.google.com with SMTP id d40so2502269and.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 03:12:39 -0800 (PST)
Message-ID: <e6236e5f0901060312h6946f9a1p49e299e723cb0190@mail.gmail.com> (sfid-20090106_121245_090079_B43BFCAA)
Date: Tue, 6 Jan 2009 12:12:38 +0100
From: "Rodrigo Fresneda" <fresneda@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: trouble with compat-old
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear developers,
I recently (06-Jan-09) tried to compile the compat-wireless-2.6-old
drivers to use with my intel wifi 5100 (Intel Corporation PRO/Wireless 5100
AGN [Shiloh]) in debian lenny with generic kernel 2.6.26-1-amd64
Compilation went fine until it tried to build iwlagn, when the following
error message was displayed:

WARNING: "iwl4965_agn_cfg"
[/home/fresneda/compat-wireless-2.6-old/drivers/net/wireless/iwlwifi/iwlagn.ko]
undefined!

The module is built, but it cannot be inserted:

FATAL: Error inserting iwlagn
(/lib/modules/2.6.26-1-amd64/updates/drivers/net/wireless/iwlwifi/iwlagn.ko):
Unknown symbol in module, or unknown parameter (see
dmesg)

And the output of dmesg:

iwlagn: Unknown symbol iwl4965_agn_cfg

Is there a simple workaround? Unfortunately, I cannot use a kernel >=2.6.27,
because of sound and video issues.
best regards,
rodrigo.
