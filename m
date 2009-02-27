Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:54615 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010AbZB0RzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 12:55:18 -0500
Received: by bwz26 with SMTP id 26so1136628bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 27 Feb 2009 09:55:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ee588a540902270946h13e03b6el71de5237a458b7a3@mail.gmail.com>
References: <ee588a540902270946h13e03b6el71de5237a458b7a3@mail.gmail.com>
Date: Fri, 27 Feb 2009 18:55:15 +0100
Message-ID: <ee588a540902270955j214d98d2uf58858d12a7787cc@mail.gmail.com> (sfid-20090227_185523_004989_C9DD2D9E)
Subject: Fwd: b43* linux driver, more ids dev
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fwd to linux-wireless@vger.kernel.org


---------- Forwarded message ----------
=46rom: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Fri, Feb 27, 2009 at 18:46
Subject: b43* linux driver, more ids dev
To: mb@bu3sch.de, Larry.Finger@lwfinger.net,
johannes@sipsolutions.net, stefano.brivio@polimi.it


hi,

are there any trouble with these devices ? why are they not =A0inside
b43* drivers ?

PCI_VENDOR_ID_BROADCOM, 0x4313
PCI_VENDOR_ID_BROADCOM, 0x4315
PCI_VENDOR_ID_BROADCOM, 0x432a
PCI_VENDOR_ID_BROADCOM, 0x432b
PCI_VENDOR_ID_BROADCOM, 0x432c
PCI_VENDOR_ID_BROADCOM, 0x432d


taken from the vendor's driver src:
http://www.broadcom.com/docs/linux_sta/hybrid-portsrc-x86_32-v5_10_27_1=
4.tar.gz

more info at: http://www.broadcom.com/support/802.11/linux_sta.php


-thanks-


regards,
--
Polycommander, Erkowit, Urquiola, Andros Patria, Cason, Aegean Sea,
Prestige, ...



--=20
Polycommander, Erkowit, Urquiola, Andros Patria, Cason, Aegean Sea,
Prestige, ...
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
