Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:35301 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZGaMcL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 08:32:11 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: RTL8192SE support status
Date: Fri, 31 Jul 2009 14:31:16 +0200
Cc: linux-wireless@vger.kernel.org, Greg KH <greg@kroah.com>
MIME-Version: 1.0
Message-Id: <200907311431.17043.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

I've been getting some private mail regarding the status of RTL8192SE
wireless chipset support (the chipset is used in some newer netbooks,
i.e. Medion Akoya E1312) so the current situation is:

* I'm not working on it and I don't know if/when the driver is coming.

* Realtek has been queried about the issue two weeks ago but we haven't
  heard anything back yet.

* rtl8192su driver present in staging area of the kernel is for RTL8192SU
  (USB version of the chipset) and never contained working/complete code
  for RTL8192SE (PCI-E version of the chipset) so there is no point in
  attempts of reverting some patches in hope that it will make the things
  magically work (it won't, please save your time).

Thanks,
Bart
