Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2476 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756903Ab2KVUcg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 15:32:36 -0500
Message-ID: <50AE8BD3.8040902@broadcom.com> (sfid-20121122_213245_062535_2F1908CF)
Date: Thu, 22 Nov 2012 21:32:19 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: brcmsmac tx patches for 3.7
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

When Seth posted his rework on brcmsmac transmit, we had a number of
patches ready in the same area albeit less rigorous. With Seth's patches
lined up in wireless-next for 3.8, I am wondering what to do here.
Should I send our patches against the wireless tree? These patches will
definitely result in conflicts when merging to wireless-next, which you
typically do. Actually, we do not want these patches in wireless-next as
rework from Seth makes them irrelevant.

Any advice on this?

Gr. AvS

