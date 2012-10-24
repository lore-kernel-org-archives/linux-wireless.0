Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:45641 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934814Ab2JXOHU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 10:07:20 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath6kl-devel@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: ath6kl-next branch rebased
Date: Wed, 24 Oct 2012 17:07:09 +0300
Message-ID: <87pq480xrm.fsf@qca.qualcomm.com> (sfid-20121024_160725_814505_A2DC3D14)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I had to rebase ath6kl-next branch in ath6kl.git due to a commit
immediately followed by a revert. Most likely our upstream maintainers
don't like that so I wanted to avoid a publig flogging =)

The downside is that some of the commit ids have changed. But master
branch is unaffected, the users of master branch can still do 'git pull'
and everything will just work. I also updated master branch to
3.7-rc2-wl.

But don't even dream about using bisect on the master branch, the
history on that branch is so ugly that it won't work. For bisect or
checking the git history I recommend to use ath6kl-next branch.

Kalle
