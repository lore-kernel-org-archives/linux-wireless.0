Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:10849 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbYLJPNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 10:13:46 -0500
Received: by qw-out-2122.google.com with SMTP id 3so155278qwe.37
        for <linux-wireless@vger.kernel.org>; Wed, 10 Dec 2008 07:13:45 -0800 (PST)
Message-ID: <e27b78a40812100713l588e5cfch952c3d909c1dea19@mail.gmail.com> (sfid-20081210_161349_313917_9BFFAA0F)
Date: Wed, 10 Dec 2008 15:13:45 +0000
From: Keir <keirlawson@gmail.com>
To: "Andrey Yurovsky" <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Subject: Listing established mesh connections
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I was wondering if there was an efficient way to get a list of
established mesh connections for a given mesh network?  I'm working on
a custom link metric (Packet pair) for the o11s stack and want to
unicast a packet to each established connection.  I have been reading
through the HWMP code, but it doesn't seem clear to me how this code
gets a list of its neighbors.

Cheers

Keir
