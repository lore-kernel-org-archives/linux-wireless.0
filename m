Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.186]:64608 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYLARuN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 12:50:13 -0500
Received: by rn-out-0910.google.com with SMTP id k40so2015586rnd.17
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 09:50:12 -0800 (PST)
Message-ID: <43e72e890812010950n197c6301u4a2fcb3d943fc116@mail.gmail.com> (sfid-20081201_185017_832427_409774E0)
Date: Mon, 1 Dec 2008 09:50:11 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Note to distributions: don't use ath0 for ath5k/ath9k
Cc: "Tim Gardner" <tim.gardner@canonical.com>,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Small silly note: please try to drop the ath%d name from udev for
atheros devices. This was a MadWifism.

I think this is static udev rules...

  Luis
