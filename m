Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:39768 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab3IKI7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 04:59:51 -0400
Received: by mail-la0-f43.google.com with SMTP id ep20so7205043lab.16
        for <linux-wireless@vger.kernel.org>; Wed, 11 Sep 2013 01:59:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <DUB122-W36FEB8099A8B6081E03DDBF7390@phx.gbl>
References: <DUB122-W36FEB8099A8B6081E03DDBF7390@phx.gbl>
Date: Wed, 11 Sep 2013 11:59:49 +0300
Message-ID: <CANUX_P2HG+j_kJ03WZe34Lf_9GPFnaTC_Ka--DP+xm1PDwtN5w@mail.gmail.com> (sfid-20130911_110003_938030_EBB66434)
Subject: Re: iwlwifi crash with "Microcode SW error detected"
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "Toufilk ..." <toufik2@hotmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

thanks for your report

> [   74.374420] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
> [   74.374429] iwlwifi 0000:01:00.0: Status: 0x00000000, count: 6
> [   74.374438] iwlwifi 0000:01:00.0: 0x0000003C | NMI_INTERRUPT_DATA_ACTION_PT
> [   74.374445] iwlwifi 0000:01:00.0: 0x059002A3 | uPc
> [   74.374452] iwlwifi 0000:01:00.0: 0x00000000 | branchlink1
> [   74.374459] iwlwifi 0000:01:00.0: 0x00000C8A | branchlink2
> [   74.374466] iwlwifi 0000:01:00.0: 0x00014078 | interruptlink1
> [   74.374473] iwlwifi 0000:01:00.0: 0x00000676 | interruptlink2
> [   74.374480] iwlwifi 0000:01:00.0: 0x00014D9A | data1
> [   74.374486] iwlwifi 0000:01:00.0: 0x00000008 | data2
> [   74.374493] iwlwifi 0000:01:00.0: 0x03030000 | data3
> [   74.374500] iwlwifi 0000:01:00.0: 0x59009500 | beacon time
> [   74.374507] iwlwifi 0000:01:00.0: 0x539A8E27 | tsf low
> [   74.374514] iwlwifi 0000:01:00.0: 0x00000040 | tsf hi
> [   74.374521] iwlwifi 0000:01:00.0: 0x00000000 | time gp1
> [   74.374528] iwlwifi 0000:01:00.0: 0x0431E87A | time gp2
> [   74.374534] iwlwifi 0000:01:00.0: 0x00000000 | time gp3
> [   74.374541] iwlwifi 0000:01:00.0: 0x00321600 | uCode version
> [   74.374548] iwlwifi 0000:01:00.0: 0x00000144 | hw version
> [   74.374555] iwlwifi 0000:01:00.0: 0x00489204 | board version
> [   74.374562] iwlwifi 0000:01:00.0: 0x0018001C | hcmd
> [   74.374569] iwlwifi 0000:01:00.0: 0x26F63800 | isr0
> [   74.374575] iwlwifi 0000:01:00.0: 0x01018000 | isr1
> [   74.374582] iwlwifi 0000:01:00.0: 0x0000000A | isr2
> [   74.374589] iwlwifi 0000:01:00.0: 0x4041FC81 | isr3
> [   74.374596] iwlwifi 0000:01:00.0: 0x00000000 | isr4
> [   74.374603] iwlwifi 0000:01:00.0: 0x10800112 | isr_pref
> [   74.374609] iwlwifi 0000:01:00.0: 0x00014D9A | wait_event
> [   74.374616] iwlwifi 0000:01:00.0: 0x000000D0 | l2p_control
> [   74.374623] iwlwifi 0000:01:00.0: 0x00019C20 | l2p_duration
> [   74.374630] iwlwifi 0000:01:00.0: 0x0000003F | l2p_mhvalid
> [   74.374637] iwlwifi 0000:01:00.0: 0x000000CF | l2p_addr_match
> [   74.374644] iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel
> [   74.374651] iwlwifi 0000:01:00.0: 0xA3925B33 | timestamp
> [   74.374658] iwlwifi 0000:01:00.0: 0x00346878 | flow_handler
> [   74.374667] ieee80211 phy0: Hardware restart was requested

This is a firmware issue that has been fixed in later versions that we
haven't released yet. I hope that I will able to release the new
firmware very soon.
