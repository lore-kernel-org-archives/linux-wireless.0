Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:4025 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451Ab0CaGiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 02:38:46 -0400
From: Holger Schurig <holgerschurig@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Broadcom card totally not visible for system (lspci)
Date: Wed, 31 Mar 2010 08:39:42 +0200
Cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
References: <b170af451003300956r7fbd7812jdb40d125aeaf1b32@mail.gmail.com> <4BB2328D.9010503@lwfinger.net>
In-Reply-To: <4BB2328D.9010503@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201003310839.42778.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> (1) It is disabled in the BIOS.

I once had a geode-based tablet PC with a buggy ACPI, where the device hang 
when I used the buttons extensively).

In the end, I dumped the ACPI bios and disassembled it with "iasl". Once you 
get a grip to the mnemonics, disassembled ACPI opcodes are quite readable. I 
found some quite interesting things about the tablet that haven't been 
documented anywhere, e.g. most of the internal GPIO.

So, if your polish friend is willing to go this route ... that's at least a 
possibility.

-- 
http://www.holgerschurig.de
