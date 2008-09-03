Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:58673 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbYICDAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:00:39 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1524173yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2008 20:00:38 -0700 (PDT)
Message-ID: <43e72e890809022000j20d64256ubd21dba79f7d6ff1@mail.gmail.com> (sfid-20080903_050042_814301_7249A7BD)
Date: Tue, 2 Sep 2008 20:00:38 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: compat-wireless -- two new trees
Cc: compat-masters@lists.madwifi.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As promised, we now have two trees for compat-wireless:

kernels <= 2.6.26
git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6-old.git
kernels >= 2.6.27
git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6.git

The compat-wireless-2.6-old.git tree is a self contained git-tree,
meaning we no longer update it automatically from wireless-testing.
This also means patches are manually put into the tree. If you're  a
driver maintainer or developer want to see some patches in that tree
please send them my way. Pull requests are easier if they are from
maintainers. I'd actually prefer if someone took over maintenance of
the old tree but I'll do it for now and I'll try to do my best to keep
it updated. No promises though.

I will promise to keep the new shiny compat-wireless-2.6.git tree up
to date. This one is just as it was before except we remove all the
old cruft and strat fresh.

I've made it so two tarballs are made daily based on these trees. You
can already get the compat-wireless-2.6-old tarball (now with ath9k),
but remember its self contained so you can simply git-clone and make
and you'll be set too. To not pster the linux-wireless list with
compat patches please bug me on compat-masters list. If you are
interested in helping please subscribe to that list too.

Patches for compat-wireless of for the new tree can go on linux-wireless.

As usual, read more about it at:

http://wireless.kernel.org/en/users/Download

  Luis
