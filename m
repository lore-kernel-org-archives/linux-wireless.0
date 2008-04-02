Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:42251 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbYDBLyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 07:54:20 -0400
Received: by fg-out-1718.google.com with SMTP id l27so2858132fgb.17
        for <linux-wireless@vger.kernel.org>; Wed, 02 Apr 2008 04:54:19 -0700 (PDT)
Date: Wed, 2 Apr 2008 13:54:03 +0200
To: "Felipe Maya" <fmay@cetuc.puc-rio.br>
Cc: linux-wireless@vger.kernel.org
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
Message-ID: <20080402135403.7fa54310@localhost> (sfid-20080402_125424_554434_CFEC3541)
In-Reply-To: <36899.201.36.161.238.1207134354.squirrel@mamao.cetuc.puc-rio.br>
References: <20080402001213.7b879a73@localhost>
	<36899.201.36.161.238.1207134354.squirrel@mamao.cetuc.puc-rio.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
From: TK <tobutaz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le Wed, 2 Apr 2008 08:05:54 -0300 (BRT),
"Felipe Maya" <fmay@cetuc.puc-rio.br> a =C3=A9crit :
> filename:     =20
> /lib/modules/2.6.23.1/kernel/drivers/net/wireless/rt2x00/rt2500pci.ko
> license:        GPL
> description:    Ralink RT2500 PCI & PCMCIA Wireless LAN driver.
> version:        2.0.8
> author:         http://rt2x00.serialmonkey.com
> srcversion:     C8DB886C372334BFB58A7F5
> alias:          pci:v00001814d00000201sv*sd*bc*sc*i*
> depends:        rt2x00pci,rt2x00lib,mac80211,eeprom_93cx6
> vermagic:       2.6.23.1 SMP mod_unload 686 4KSTACKS

Don't tell me, tell the list.
Even then, I am not sure this is enough info to help you, since there
are no obvious error messages.
Maybe this is simply ad-hoc mode being broken in rt2x00, I think this
code is too new. You could try with a way more recent kernel
(the wireless-testing tree suggested above), or check that the legacy
driver does ad-hoc (I think it does).

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
