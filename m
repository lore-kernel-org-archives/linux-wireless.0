Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:40873 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753265AbXKERtc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2007 12:49:32 -0500
Message-ID: <472F57A6.3020107@lwfinger.net> (sfid-20071105_174935_745352_007D3D5F)
Date: Mon, 05 Nov 2007 11:49:26 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Problem with wireless-2.6
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

I did the following set of steps:

git clone --reference ~/linux-2.6 \
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git junk

cd junk
git checkout -b everything origin/everything
git pull
Warning: No merge candidate found because value of config option
         "branch.everything.merge" does not match any remote branch fetched.
No changes.

I know that when I get the above warning, my branch "everything" is never updated. My previous
wireless-2.6 tree was stuck at 2.6.23-rc9, whereas "git describe" lists the new tree at
v2.6.24-rc1-155-g792296c.

What am I doing wrong?

Larry

