Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:52321 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755329Ab0FPAgB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 20:36:01 -0400
Subject: Compat-wireless release for 2010-06-15 is baked
To: <linux-wireless@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>
Message-Id: <20100616003557.B310842E16@repository3.localdomain>
Date: Tue, 15 Jun 2010 20:35:57 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
make: gcc: Command not found
make: Entering directory `/usr/src/linux-headers-2.6.31-14-server'
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
/usr/src/linux-headers-2.6.31-14-server/arch/x86/Makefile:80: stack protector enabled but no compiler support
make[1]: gcc: Command not found
scripts/Makefile.clean:17: /var/opt/compat/compat-wireless-2.6/drivers/net/wireless/hostap/Makefile: No such file or directory
make[4]: *** No rule to make target `/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/hostap/Makefile'.  Stop.
make[3]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/hostap] Error 2
make[2]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless] Error 2
make[1]: *** [_clean_/var/opt/compat/compat-wireless-2.6] Error 2
make: *** [clean] Error 2
make: gcc: Command not found
make: Entering directory `/usr/src/linux-headers-2.6.31-14-server'
/usr/src/linux-headers-2.6.31-14-server/arch/x86/Makefile:80: stack protector enabled but no compiler support
make[1]: gcc: Command not found
make: gcc: Command not found
make: Entering directory `/usr/src/linux-headers-2.6.31-14-server'
/usr/src/linux-headers-2.6.31-14-server/arch/x86/Makefile:80: stack protector enabled but no compiler support
make[1]: gcc: Command not found

compat-wireless code metrics

    498409 - Total upstream lines of code being pulled
      1398 - backport code changes
      1167 - backport code additions
       231 - backport code deletions
      5748 - backport from compat module
      7146 - total backport code
    1.4338 - % of code consists of backport work
        13 - Code changes posted but not yet merged
         8 - Code additions posted but not yet merged
         5 - Code deletions posted but not yet merged
    0.0026 - % of code not yet merged
      1218 - Crap changes not yet posted
      1179 - Crap additions not yet merged
        39 - Crap deletions not yet posted
    0.2444 - % of crap code

Base tree: linux-next.git
Base tree version: next-20100615
compat-wireless release: compat-wireless-2010-06-10-11-gd1c4956
