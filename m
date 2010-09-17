Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:42064 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756187Ab0IQTEA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 15:04:00 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 1683C418D8
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 15:02:16 -0400 (EDT)
Subject: Compat-wireless release for 2010-09-17 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100917190358.66FBD41134@repository3.orbit-lab.org>
Date: Fri, 17 Sep 2010 15:03:57 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   abc3a88..103f01c  history    -> origin/history
 + 09e4703...cb131d8 master     -> origin/master  (forced update)
   9c03f16..03a7ab0  stable     -> origin/stable
 * [new tag]         next-20100917 -> next-20100917
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
