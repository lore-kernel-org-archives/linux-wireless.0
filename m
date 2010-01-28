Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:1055 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab0A1O3M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 09:29:12 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: scan does not work
Date: Thu, 28 Jan 2010 15:28:36 +0100
Cc: Sriram V <vshrirama@gmail.com>
References: <8bf247761001280439u59a9b6ch1128d42a83116594@mail.gmail.com> <8bf247761001280607i2b90f73j96e3afd02fb6da29@mail.gmail.com>
In-Reply-To: <8bf247761001280607i2b90f73j96e3afd02fb6da29@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201001281528.37342.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> libertas cmd: DNLD_CMD: command 0x0006, seq 9, size 63

That is the scan command.

> libertas cmd: CMD_RESP: response 0x8006, seq 9, size 11

And that the scan response. As I can see from the size (11 
bytes), it doesn't contain any results. The same happens with 
the other scan-responses:

> libertas cmd: CMD_RESP: response 0x8006, seq 10, size 11
> libertas cmd: CMD_RESP: response 0x8006, seq 11, size 11
> libertas cmd: CMD_RESP: response 0x8006, seq 12, size 11
> libertas cmd: CMD_RESP: response 0x8006, seq 13, size 11
> libertas cmd: CMD_RESP: response 0x8006, seq 14, size 11

I'd suggest you check your antenna.

-- 
http://www.holgerschurig.de
