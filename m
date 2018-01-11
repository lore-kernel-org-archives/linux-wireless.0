Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from macoma.schafweide.org ([185.194.141.93]:35012 "EHLO
        macoma.schafweide.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932415AbeAKMeb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Jan 2018 07:34:31 -0500
Received: from [IPv6:2001:67c:18e8:2:a04c:bf3f:f886:aef8] (unknown [IPv6:2001:67c:18e8:2:a04c:bf3f:f886:aef8])
        by macoma.schafweide.org (Postfix) with ESMTPSA id DCAD6214C2
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jan 2018 13:27:54 +0100 (CET)
To: linux-wireless@vger.kernel.org
From: Bjoern Franke <bjo@nord-west.org>
Subject: Status of brcmsmac regarding BCM43228
Message-ID: <36b8ce09-cf39-77b4-f638-a8669e3b4da6@nord-west.org> (sfid-20180111_133435_012680_C62EA2D6)
Date: Thu, 11 Jan 2018 13:27:54 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I recently got a Thinkpad, which unfortunately has a BCM43228. The
b43-driver only sees the 2,4GHz WiFI and connects with 54Mbit/s, while
the wl-driver has good connection speeds using the 5GHz net - well, when
it connects.

According to the to-be-done-list of brcmsmac, support for BCM43228
should be added (among others), but I did not see any commit regarding
BCM43228 since 2014.

So, support for BCM43228 within brcmsmac is far far away?


Kind regards
Bjoern
