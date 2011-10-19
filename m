Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45421 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073Ab1JSM7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 08:59:49 -0400
Received: by vcge1 with SMTP id e1so1442479vcg.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Oct 2011 05:59:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <F099D0EF3989304DBA09D2E81781FF0B049E41F9@BLR-SJP-MBX4.wipro.com>
References: <F099D0EF3989304DBA09D2E81781FF0B049E41F9@BLR-SJP-MBX4.wipro.com>
Date: Wed, 19 Oct 2011 14:59:46 +0200
Message-ID: <CAOZOX0XfeX4_JqoXg_Z8VFrfhtR8BrpuoR+rDbE34_dXY4fDgw@mail.gmail.com> (sfid-20111019_145952_817416_2EB4130B)
Subject: Re: Ralink RT3070: absolute transmit power information
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: raghunathan.kailasanathan@wipro.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 19, 2011 at 2:40 PM,  <raghunathan.kailasanathan@wipro.com> wrote:
> Hi all,
> On my ubuntu machine I can view transmit power used by RT3070 driver using "iwpriv ra0 show TxPower".
> It looks like this returns results in percentage - I got 75 (implying 75%).
>
> How do I get the absolute transmit power used (in dBm or mW) ?

You are using a driver not supported by this project,
so you have to manually change the Ralink driver source code yourself.
When you use the rt2x00 drivers, you automatically get the dBm/mW value.

Ivo
