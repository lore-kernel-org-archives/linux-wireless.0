Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:20207 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbYJDUU0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 16:20:26 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2238059rvb.1
        for <linux-wireless@vger.kernel.org>; Sat, 04 Oct 2008 13:20:25 -0700 (PDT)
Message-ID: <c9d168940810041320p1b09b1f6i51f898011b14b26d@mail.gmail.com> (sfid-20081004_222030_634700_CCE9E896)
Date: Sat, 4 Oct 2008 12:20:25 -0800
From: Ramesh <rramesh1@gmail.com>
To: wireless <linux-wireless@vger.kernel.org>
Subject: Question on git pull
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am newbie to linux-wireless, I recently got a copy of the source
from the wireless-testing branch by the following method:

git-clone git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
cd wireless-testing
git-pull

I wanted to work on my own branch so I created a new branch as below:

git-checkout -b mac80211-stats-change

I have a few questions at this point :

How do I keep this branch updated with checkins in the master branch?

Thanks
Ramesh
