Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:47288 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaHNSMc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2014 14:12:32 -0400
Received: by mail-la0-f48.google.com with SMTP id gl10so1478215lab.21
        for <linux-wireless@vger.kernel.org>; Thu, 14 Aug 2014 11:12:30 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 14 Aug 2014 11:12:30 -0700
Message-ID: <CANUX_P0LJqMS40k=8jeie3q=nbXsA4qO39TL3G9gkp+cTshMCw@mail.gmail.com> (sfid-20140814_201235_642182_42195257)
Subject: pull request: iwlwifi-2014-08-14
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is a pull request with one patch that fixes an issue faced by Linus.

David Spinadel helped me debugging this and it appears that the
firmware currently available doesn't support scheduled scan. So we
disable that for now.

I am sorry - but I am travelling right now and my connection to the
only computer that has my PGP signature is awfully slow...
Please pull. I'll try to sign a reply to this message as soon as I can.

Thanks,

The following changes since commit 2da2c5854ed759a64f8a9231a7f544b472c3aa6d:

  net: wireless: ipw2x00: ipw2200.c: Cleaning up missing
null-terminate after strncpy call (2014-08-11 14:43:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git
for-john

for you to fetch changes up to 77b2f2865956b7573f9b040db7a9f808b434acd1:

  iwlwifi: mvm: disable scheduled scan to prevent firmware crash
(2014-08-14 19:47:41 +0300)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: mvm: disable scheduled scan to prevent firmware crash

 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
