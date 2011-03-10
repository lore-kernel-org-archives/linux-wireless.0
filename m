Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62451 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab1CJK4p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 05:56:45 -0500
Received: by qwd7 with SMTP id 7so1092423qwd.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 02:56:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20110310T112254-310@post.gmane.org>
References: <AANLkTim9hhX1VV93X7-+61hNsxit=AJiHgrt9ByWg9+V@mail.gmail.com>
	<loom.20110310T112254-310@post.gmane.org>
Date: Thu, 10 Mar 2011 11:56:44 +0100
Message-ID: <AANLkTimrX0tQ4=_03q_--Ad12+rvWgLGskeUHkpHyJr2@mail.gmail.com>
Subject: Re: Problem with BCM943224
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/10 Arend van Spriel <arend@broadcom.com>:
> Rafał Miłecki <zajec5@...> writes:
>> It seems all reads are 1 (0xffffffff). Can this be some bug in driver?
>> Can this be because I use adapter mini PCIe to PCIe x1? I remember
>> such a situation when I connected adapter to PCIe x16 and used N-PHY
>> card SSB based.
>>
>
> I am using a Dell laptop (Latitude E6410) with 43224 installed and no
> issues with it. We also have a test setup over here which is a desktop
> model in which we use the 4313 in half-mini-pci to PCIe x1 adapter. Also
> had 43224 in same adapter and both did not give issues with the si_attach,
> which scans the chipset for the cores. Reading back 0xFFFFFFFF is reason
> to abort this scan and end in a failure.

Thank you for answer. Could you send me photo of your adapter? Do you
know where it was bought?

Could you (Broadcom) donate me with a one or two such a adapters?

-- 
Rafał
