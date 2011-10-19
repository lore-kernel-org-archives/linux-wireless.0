Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wipro-blr-out01.wipro.com ([203.91.198.74]:43006 "EHLO
	wipro-blr-out01.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab1JSN3c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 09:29:32 -0400
From: <raghunathan.kailasanathan@wipro.com>
To: <ivdoorn@gmail.com>
CC: <linux-wireless@vger.kernel.org>
Subject: RE: Ralink RT3070: absolute transmit power information
Date: Wed, 19 Oct 2011 13:29:27 +0000
Message-ID: <F099D0EF3989304DBA09D2E81781FF0B049E423D@BLR-SJP-MBX4.wipro.com> (sfid-20111019_152935_381508_F6235F1D)
References: <F099D0EF3989304DBA09D2E81781FF0B049E41F9@BLR-SJP-MBX4.wipro.com>
 <CAOZOX0XfeX4_JqoXg_Z8VFrfhtR8BrpuoR+rDbE34_dXY4fDgw@mail.gmail.com>
In-Reply-To: <CAOZOX0XfeX4_JqoXg_Z8VFrfhtR8BrpuoR+rDbE34_dXY4fDgw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>You are using a driver not supported by this project,
>so you have to manually change the Ralink driver source code yourself.
>When you use the rt2x00 drivers, you automatically get the dBm/mW value.

Is there a source tarball of rt2x00 available somewhere ? git ports are blocked by firewall and 
this link does not work :
http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=summary

--Raghu

