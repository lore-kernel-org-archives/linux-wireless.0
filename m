Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34070 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbbGCJeN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2015 05:34:13 -0400
Received: by wgqq4 with SMTP id q4so83707696wgq.1
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jul 2015 02:34:11 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 3 Jul 2015 10:34:11 +0100
Message-ID: <CAFSTUk6UasnV4P3B1TR7kSx1ToQTC+PC2hU6PynDBWJ3ALJzyg@mail.gmail.com> (sfid-20150703_113547_793129_F137D98A)
Subject: mesh support on rtl8192cu
From: Richard Palethorpe <richard@lm-technologies.com>
To: ap420073@gmail.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Taehee,

I have been experimenting with MESH mode on kernel 4.0.7. It is
sending beacons out, but is unable to establish a connection.

I have two rtl8192cu based dongles connected to identical VMs and am
using the following commands to set up the mesh:

iw dev wls160u2 set type mesh
ip addr add 192.168.2.1/24 broadcast 192.168.2.255 dev wls160u2
ip link set wls160u2 up
iw dev wls160u2 mesh join lmmesh

Running 'iw dev wls160u2 mpath dump' produces no results and there is
nothing regarding mesh in dmesg. I can't find any other information on
mesh with rtl8192cu other than the patch which you submitted.

I am wondering if it does work, but there is a step I am missing or if
something is wrong with the code?

Thank you,
Richard.
