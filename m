Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62678 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab2LJVQu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 16:16:50 -0500
Received: by mail-vc0-f174.google.com with SMTP id d16so2922827vcd.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 13:16:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50C65059.9000501@lwfinger.net>
References: <CAMfPB_wtsXjxFkY6M4cNjxDK678DV4VPjwDRzVOtgrf-4jDL-Q@mail.gmail.com>
	<50C61570.6040006@lwfinger.net>
	<CAMfPB_xV4fCK=G12EYKxgEDBYnOEEe45AmTFCBx67pKP4y+aYQ@mail.gmail.com>
	<CAMfPB_xBUDwmoHy4RiPZiCN7itYTHW9+n9eMj89YRrg-FkZrgQ@mail.gmail.com>
	<50C65059.9000501@lwfinger.net>
Date: Mon, 10 Dec 2012 22:16:49 +0100
Message-ID: <CAMfPB_xvLQk2Z1iD7e49iPhhxv+J2J8ZKmmr0+vjaXQ-xdcAsg@mail.gmail.com> (sfid-20121210_221704_326559_EE15637F)
Subject: Re: 8192cu misbehaviours with RTL8188RU chipset
From: Alessandro Lannocca <alessandro.lannocca@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/12/10 Larry Finger <Larry.Finger@lwfinger.net>:
> modinfo rtl8172cu | grep -v alias

Here you are:

<snip>

filename:
/lib/modules/3.5.0-19-generic/updates/drivers/net/wireless/rtlwifi/rtl8192cu/rtl8192cu.ko
firmware:       rtlwifi/rtl8192cufw.bin
description:    Realtek 8192C/8188C 802.11n USB wireless
license:        GPL
author:         Larry Finger    <Larry.Finger@lwfinger.net>
author:         Ziv Huang    <ziv_huang@realtek.com>
author:         Georgia        <georgia@realtek.com>
srcversion:     DB3CA4D8CA86F098980FA95
depends:        rtlwifi,mac80211,rtl8192c-common,compat
vermagic:       3.5.0-19-generic SMP mod_unload modversions 686
parm:           swenc:Set to 1 for software crypto (default 0)
 (bool)
parm:           debug:Set debug level (0-5) (default 0) (int)


</snip>
