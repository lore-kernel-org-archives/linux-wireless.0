Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.228]:56148 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbXIFDG6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2007 23:06:58 -0400
Received: by nz-out-0506.google.com with SMTP id s18so26536nze
        for <linux-wireless@vger.kernel.org>; Wed, 05 Sep 2007 20:06:58 -0700 (PDT)
Message-ID: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com>
Date: Wed, 5 Sep 2007 23:06:57 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Kernel panic with rt2500pci built-in
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I receive a kernel panic with rt2500pci built-in, but if built as a
module, I can insmod it without problem. I don't have a serial
console, and I tried to capture the panic with netconsole (using a
different interface of course) but the panic happens immediately after
rt2500pci is initialized, or in other words, too soon for netconsole.

I'd rather not copy over everything unless necessary. Here's the first portion:

ACPI: PCI Interrupt 0000:02:0a.0[A] -> GSI 22 (level, low) -> IRQ 18
phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 0201, rf: 0003,
rev: 00000004
WARNING: at lib/kref.c:33 kref_get()
[<c0229da9>] kref_get+0x3d/0x44
