Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52723 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab1FUJ7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 05:59:18 -0400
Received: by iwn6 with SMTP id 6so1925183iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 02:59:17 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 21 Jun 2011 11:59:17 +0200
Message-ID: <BANLkTimvMcb5yRHSE91VPTLdy7k5WEDo0Q@mail.gmail.com> (sfid-20110621_115921_361807_C505F53E)
Subject: Re: Makefile deletes previous driver install when two WiFi interfaces
 are from the same chip vendor
From: Fred Plissonneau <cohomewp4@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fred Plissonneau <cohomewp4@gmail.com>
To: linux-wireless@vger.kernel.org


Anyone can help ?

Thanks

On Tue, Jun 14, 2011 at 4:19 PM, ch wp4 <cohomewp4@gmail.com> wrote:
> Hello,
>
> I am facing an issue during installation of an external USB-WiFi stick
> on my Linux box (Ubuntu 10.04).
> Actually, I have already successfully compiled and installed ath9k
> driver using compat-wireless-2.6.38.2-2.
> The internal WiFi NIC is fully operational.
> Now, I want to add temporarily an external USB-WiFi stick (D-Link DWA
> 160). I've found that this hardware
> is using an ar9170 chipset and therefore I've recompiled
> compat-wireless targeting now the carl9170 driver.
> Once again, this working perfectly.
> But when I switch-off and back on my PC, only the latest installed
> WiFi interface is working.
>
> Digging into the system, I've found that ath9k has disappeared from the
> /lib/modules/2.6.32-27-generic/updates/drivers/net/wireless/ath directory.
> It looks like the 'make install' command is doing some cleaning which
> has, in my particular use case, an undesirable
> side-effect.
> Can someone point me to the line in the Makefile causing this problem
> or is it the desired behaviour ?
>
> Thanks for your help
> Fred Plissonneau
>
