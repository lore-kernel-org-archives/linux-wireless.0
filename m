Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38048 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab1IHJCW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 05:02:22 -0400
Message-ID: <4E688488.5030001@qca.qualcomm.com> (sfid-20110908_110225_865050_A1771407)
Date: Thu, 8 Sep 2011 12:02:00 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: ath6kl.git mirror created to github
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everyone,

as master.kernel.org is still down I created a temporary mirror to github:

https://github.com/kvalo/ath6kl

When cloning the tree please use a local repo as a reference, download
is a lot faster that way:

git clone --reference ~/linux-2.6/ git://github.com/kvalo/ath6kl.git

Let me know if there are any problems.

Kalle
