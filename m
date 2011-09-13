Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:34556 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777Ab1IMJaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 05:30:09 -0400
Received: by mail-bw0-f53.google.com with SMTP id zt12so340584bkb.12
        for <linux-wireless@vger.kernel.org>; Tue, 13 Sep 2011 02:30:07 -0700 (PDT)
Subject: wl12xx.git temporarily moved to github
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 12:30:04 +0300
Message-ID: <1315906204.18803.189.camel@cumari> (sfid-20110913_113013_372201_239A1B64)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Due to the unfortunate downtime of git.kernel.org and friends, I've
cloned the wl12xx.git repository temporarily into github.  When
git.kernel.org comes back up, wl12xx integration will move back to it.

For now, please use this:

git://github.com/lucacoelho/wl12xx.git

The branches are still the same:

* master: ongoing integration based on wireless-testing
* wl12xx-next: ongoing integration based on wireless-next
* for-linville: branch which I use to send pull requests to John.

Thanks for your understanding.

-- 
Cheers,
Luca.

