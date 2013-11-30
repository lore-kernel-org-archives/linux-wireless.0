Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:59143 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab3K3MMM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 07:12:12 -0500
Received: by mail-oa0-f50.google.com with SMTP id n16so11230461oag.23
        for <linux-wireless@vger.kernel.org>; Sat, 30 Nov 2013 04:12:12 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 30 Nov 2013 14:12:12 +0200
Message-ID: <CAGXs5wXPB2WvuxfXzuyDaGS5_cA+GG5vHkHO+PnnVncvOwJTDg@mail.gmail.com> (sfid-20131130_131217_199581_DE585625)
Subject: wireless network interfaces and network namespaces
From: Kevin Wilson <wkevils@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
I am trying to move a wireless interface to a network namespace I
created and I get an error:

ip link set wlan0 netns ns1
RTNETLINK answers: Invalid argument

I do it with latest iproute2 git sources,  on 3.8 kernel.

I want to verify this: all wireless interfaces do no support
network namespace. Is this true ? what in fact is the reason for this ?

regards,
Kevin
