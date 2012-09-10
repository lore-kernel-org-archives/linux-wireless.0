Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54075 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2IJRdY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 13:33:24 -0400
Received: by eekc1 with SMTP id c1so1360172eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Sep 2012 10:33:23 -0700 (PDT)
Date: Mon, 10 Sep 2012 19:33:09 +0200
From: Anisse Astier <anisse@astier.eu>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?B?5p2O5pyd?= =?UTF-8?B?5piO?=
	<chaoming_li@realsil.com.cn>
Subject: Re: rtl8192ce: activation problem with rtl8188ce pci card
Message-ID: <20120910193309.1f901d65@destiny.ordissimo> (sfid-20120910_193328_322596_77D80784)
In-Reply-To: <5048F3D8.9030509@lwfinger.net>
References: <20120905185510.2ab501cd@destiny.ordissimo>
	<50478E10.6030808@lwfinger.net>
	<20120905201437.70c008ca@destiny.ordissimo>
	<5047B508.5030606@lwfinger.net>
	<20120906161529.016b2202@destiny.ordissimo>
	<5048D138.1080109@lwfinger.net>
	<20120906202710.30c4bc8a@destiny.ordissimo>
	<5048F3D8.9030509@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 06 Sep 2012 14:04:56 -0500, Larry Finger
<Larry.Finger@lwfinger.net> wrote :

> > [  518.708755] rtl8192ce-0:_rtl92ce_read_adapter_info():<0-0> EEPROMId = 0x8129
> > [  518.708766] rtl8192ce-0:_rtl92ce_read_adapter_info():<0-0> EEPROM VID = 0x10ec
> > [  518.708776] rtl8192ce-0:_rtl92ce_read_adapter_info():<0-0> EEPROM DID = 0x8176
> > [  518.708787] rtl8192ce-0:_rtl92ce_read_adapter_info():<0-0> EEPROM SVID = 0x10ec
> > [  518.708797] rtl8192ce-0:_rtl92ce_read_adapter_info():<0-0> EEPROM SMID = 0x8212

I forgot to mention something.

I have a working cards with the same chip id/ module id. I haven't found
a way to diffentiate them. Basically on one card it works, and the other
it doesn't.

I also have a working card with a module id = 0x8211 (everything else is
the same).

Anisse
