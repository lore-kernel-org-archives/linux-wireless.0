Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.225]:4595 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbYK0BSH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 20:18:07 -0500
Received: by qb-out-0506.google.com with SMTP id f11so737217qba.17
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 17:18:06 -0800 (PST)
Message-ID: <14c249940811261718r29d96d00t2b62be3420d7ed74@mail.gmail.com> (sfid-20081127_021813_196084_83A41B5B)
Date: Thu, 27 Nov 2008 09:18:06 +0800
From: "c4linux c4linux" <c4linux@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: wifi drops multicast packets
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,all

   VLC playing multicast video stream to a router's WAN, and using
igmpproxy route the multicast packets to router's ath0.

   I capture the packets on both of them and found that the route has
forward the 100% muticast packets but wifi didn't send them all, wifi
drops nearly 20% the multicast packets. Why?
