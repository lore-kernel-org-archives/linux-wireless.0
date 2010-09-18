Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:52808 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756336Ab0IRTCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:42 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 4A313418D8
	for <linux-wireless@vger.kernel.org>; Sat, 18 Sep 2010 15:00:56 -0400 (EDT)
Subject: Compat-wireless release for 2010-09-18 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100918190241.5C99F404FC@repository3.orbit-lab.org>
Date: Sat, 18 Sep 2010 15:02:41 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
scripts/Makefile.clean:17: /var/opt/compat/compat-wireless-2.6/drivers/net/wireless/ath/carl9170/Makefile: No such file or directory
make[5]: *** No rule to make target `/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/ath/carl9170/Makefile'.  Stop.
make[4]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/ath/carl9170] Error 2
make[3]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/ath] Error 2
make[2]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless] Error 2
make[1]: *** [_clean_/var/opt/compat/compat-wireless-2.6] Error 2
make: *** [clean] Error 2

compat-wireless code metrics

    706813 - Total upstream lines of code being pulled
