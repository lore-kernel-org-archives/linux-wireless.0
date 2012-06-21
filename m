Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39054 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab2FUNw4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 09:52:56 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Shhod-0001AH-E2
	for linux-wireless@vger.kernel.org; Thu, 21 Jun 2012 15:52:55 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: pull-request: iwlwifi-next 2012-06-21
Date: Thu, 21 Jun 2012 15:52:50 +0200
Message-Id: <1340286773-2381-1-git-send-email-johannes@sipsolutions.net> (sfid-20120621_155259_800657_2F1E3368)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Please pull the request below, I'm also sending the patches.
Excuse the quick new pull request, but the one I sent to you
earlier was found to be defective, not sure why I missed that
earlier.

johannes

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

The following changes since commit 8d40f4eebf43bd73aa7c6e06665fd7a26012f9c9:

  iwlwifi: remove sku field from hw_params (2012-06-20 08:42:21 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john

for you to fetch changes up to e75dac921d88ac1fa1ad08686ab242556f8b888b:

  iwlwifi: limit mac_change_interface to BSS context (2012-06-21 10:01:43 +0200)

- ----------------------------------------------------------------
Johannes Berg (3):
      iwlwifi: fix radio reset scan dwell vs. quiet time
      iwlwifi: increase scan timeout
      iwlwifi: limit mac_change_interface to BSS context

 drivers/net/wireless/iwlwifi/dvm/agn.h      |    2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |   37 ++++++++++++---------------
 drivers/net/wireless/iwlwifi/dvm/scan.c     |    6 +++++
 3 files changed, 24 insertions(+), 21 deletions(-)
-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJP4ybvAAoJEDBSmw7B7bqrS9cP/0erl65XaUjcY4z5l8jc8dzA
5yGjUJHT2/iBsRLRMpAlMD+f7s3TTCURvs3xZJVcArvmRs+J2HPI7tjHx+QlFLYV
WuPyTkz89Uw5b8juNjTzVlzlGKgI04y9hhVVNOzc1x840zTGMD2VuNqh+EK/lZfW
2YYeTieqkxFnxkcywKzN8ztvtH6RU+a+dhBIuYkbFjjab6joMwbFobQV8wuvo7Gc
ueYvQ6NirD1n1c/S3QQzE4Torlkmuy105u/JeFcK3gQytpEft4qzfZxjZ3HqKJLa
h+PEeQqIE2TJ+hCYMlf0DB6aj7dl+Sr35IMZuJC5daNuHmSXBJkeI3PbXwjwoEzQ
HKnBovAXbiLYISXT79UJGRAlWXyY20Tgj1JZxFfcGegpVgQwofWGgiC+bYM+vbqe
Lv8040DmtDtYq2LYfijc/w8MEFLe5/POXOsph6wY3CjijephI9FMcVzP3qApJ5uL
5Imit3DFwjJabVkse83QhSRoV4L/Qh8uAlDYj/vPIy5phSXy5KBoXKzdkYpGujxt
ProKfFvWOKjBt6Nz3UUsDiJH9RSTc85gm5Y6OT4qTgYys73s0fZkCRaN2ub+9h8x
XEAPZ6ZNZMsnxG+acJngHnZTDZVMbfLLpJdUUy+rLw2nQcxOR30UcmO706Wym7uF
jklipKck1krfFL93vk6R
=e8cz
-----END PGP SIGNATURE-----

