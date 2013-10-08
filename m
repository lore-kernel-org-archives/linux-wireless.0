Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:4573 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab3JHF5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 01:57:08 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: ath10k: ath-next-test branch for testing patches
Date: Tue, 8 Oct 2013 08:56:59 +0300
Message-ID: <87hacstidw.fsf@kamboji.qca.qualcomm.com> (sfid-20131008_075712_767603_2CA92667)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have noticed that Fengguan's build tests are really helpful, his build
bot has found quite a few issues. To make more use of the buildbot I
have been experimenting with ath-next-test branch for running various
tests. So I'm planning to change the ath10k patch flow to this:

1. patch gets posted to the mailing lists

2. patch is immediately applied to ath-next-test

3. waiting two business days for patch being under review (unless the patch
   is urgent)

4. if no comments or warnings, the patch is applied to ath-next branch

5. ath-next is merged to master branch

6. ath-next pull requests are sent once a week (or so)

Thoughts?

-- 
Kalle Valo
