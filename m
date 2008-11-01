Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.185]:63335 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbYKAWQN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 18:16:13 -0400
Received: by rn-out-0910.google.com with SMTP id k40so1452907rnd.17
        for <linux-wireless@vger.kernel.org>; Sat, 01 Nov 2008 15:16:12 -0700 (PDT)
Message-ID: <43e72e890811011516y2e375cbem911fdca8372c909a@mail.gmail.com> (sfid-20081101_231639_239775_D8D9B1D2)
Date: Sat, 1 Nov 2008 15:16:12 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Julien HENRY" <henryju@yahoo.fr>
Subject: Re: Re : Re : Not associated with Intel 4965
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <564175.76346.qm@web28511.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <564175.76346.qm@web28511.mail.ukl.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 1, 2008 at 3:00 PM, Julien HENRY <henryju@yahoo.fr> wrote:
> OK, now I can load the module... but nothing better concerning association.
>
> Nov  1 22:39:24 Capgemini kernel: cfg80211: Using static regulatory domain info
> Nov  1 22:39:24 Capgemini kernel: cfg80211: Regulatory domain: JP
> Nov  1 22:39:24 Capgemini kernel:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> Nov  1 22:39:24 Capgemini kernel:     (2402000 KHz - 2494000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
> Nov  1 22:39:24 Capgemini kernel:     (5160000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
> Nov  1 22:39:24 Capgemini kernel:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
> Nov  1 22:39:24 Capgemini kernel: cfg80211: Calling CRDA for country: JP
> Nov  1 22:39:24 Capgemini kernel: iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
> Nov  1 22:39:24 Capgemini kernel: iwlagn: Copyright(c) 2003-2008 Intel Corporation
> Nov  1 22:39:24 Capgemini kernel: iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> Nov  1 22:39:24 Capgemini kernel: iwlagn: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
> Nov  1 22:39:24 Capgemini kernel: iwlagn: Tunable channels: 13 802.11bg, 19 802.11a channels
> ...
> Nov  1 22:39:41 Capgemini kernel: iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> Nov  1 22:39:41 Capgemini kernel: firmware: requesting iwlwifi-4965-2.ucode
> Nov  1 22:39:41 Capgemini kernel: Registered led device: iwl-phy0:radio
> Nov  1 22:39:41 Capgemini kernel: Registered led device: iwl-phy0:assoc
> Nov  1 22:39:41 Capgemini kernel: Registered led device: iwl-phy0:RX
> Nov  1 22:39:41 Capgemini kernel: Registered led device: iwl-phy0:TX
> Nov  1 22:39:41 Capgemini kernel: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> Nov  1 22:39:41 Capgemini kernel: iwlagn: TX Power requested while scanning!
> Nov  1 22:39:41 Capgemini kernel: iwlagn: Error sending TX power (-11)
>
> ...
> Nov  1 22:39:47 Capgemini kernel: iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> Nov  1 22:39:47 Capgemini kernel: Registered led device: iwl-phy0:radio
> Nov  1 22:39:47 Capgemini kernel: Registered led device: iwl-phy0:assoc
> Nov  1 22:39:47 Capgemini kernel: Registered led device: iwl-phy0:RX
> Nov  1 22:39:47 Capgemini kernel: Registered led device: iwl-phy0:TX
> Nov  1 22:39:47 Capgemini kernel: ADDRCONF(NETDEV_UP): wlan0: link is not ready
>
> Anything I can try?

Looks good to me. Try the usual commands/applications to connect to an
AP. I'm not going to help you with that.

  Luis
