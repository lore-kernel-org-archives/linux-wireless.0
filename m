Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:33315 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbbKPQCm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2015 11:02:42 -0500
Received: by wmec201 with SMTP id c201so184075450wme.0
        for <linux-wireless@vger.kernel.org>; Mon, 16 Nov 2015 08:02:41 -0800 (PST)
Message-ID: <5649FE1F.4060203@gmail.com> (sfid-20151116_170245_765425_2BFBFEA1)
Date: Mon, 16 Nov 2015 17:02:39 +0100
From: ferran <ranker72@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [question] Rate control algorithm for mesh
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everybody,

I would like to know if there is a transmit rate control algorithm out
there that takes into account the destination MAC address. My setting is
like this:

[node0]·  ·  ·  ·  ·[node1]············[node2]

Where the spaced pattern means a poor connection and the densely dotted
pattern means a good connection.

The problem here is that node1 oscillates between fast rates and slow
rates, as when transmitting to node0 it must reduce the rate, and when
transmitting to node2 it increases the rate since it must take profit of
the channel. I am therefore getting many re-tx between n1 and n0, and
n1-->n2 isn't as fast as it could.

Currently I am using the PID-based RC, but I'm afraid that this problem
isn't adressed at Minstrel neither.
Am I wrong?

Thank you for your excellent work!
Ferran

