Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55483 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab0KVP5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 10:57:04 -0500
Received: by mail-bw0-f46.google.com with SMTP id 15so6251666bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 07:57:04 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 22 Nov 2010 10:56:55 -0500
Message-ID: <AANLkTinu+xPRZyWT0_rzDXi3Z6p6BoTpLVTLdK=5yKee@mail.gmail.com>
Subject: Issue with ath9k driver
From: Martin Dubuc <martind1111@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have found an issue with the ath9k driver that first appeared in
Fedora 13 kernel and also found in latest Fedora 14 kernel
(2.6.35.6-48). I do not know if this issue was already raised and a
fix has already been identified.

When a system scans multiple channels on an ath9k interface for an
extended period of time and an application like kismet or tcpdump
monitors the interface, at some point, the application will stop
receiving packets. The period of time ranges from 30 minutes to a few
hours (generally less than 4 hours). To reproduce the problem, one can
run kismet on the interface. After a while (30 minutes to a few
hours), the interface will not receive any more packets.

The ath5k driver had similar issue in Fedora 13, but the problem was
solved in Fedora 14 kernel.

Martin
