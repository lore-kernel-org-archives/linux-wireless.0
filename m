Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:60615 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbYLRMUV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 07:20:21 -0500
Received: by bwz14 with SMTP id 14so1422850bwz.13
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2008 04:20:19 -0800 (PST)
To: "mohamed salim abbas" <mabbaswireless@gmail.com>
Subject: Re: [RFC][RFT] fix iwlagn hw-rfkill while the interface is down
Date: Thu, 18 Dec 2008 13:19:52 +0100
Cc: "Helmut Schaa" <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	yi.zhu@intel.com, reinette.chatre@intel.com
References: <200812161307.07193.helmut.schaa@gmail.com> <b3153e950812171210n7247bevc9470fa47942ce92@mail.gmail.com>
In-Reply-To: <b3153e950812171210n7247bevc9470fa47942ce92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812181319.53521.helmut.schaa@gmail.com> (sfid-20081218_132026_212565_9010012B)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 17. Dezember 2008 schrieb mohamed salim abbas:
> the interrupt moved from pci_probe to mac_start for power saving.

Out of curiosity, do you have any specific numbers of how much power can
be saved by disabling interrupts?

Thanks,
Helmut
