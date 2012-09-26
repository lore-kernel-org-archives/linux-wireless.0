Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45065 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011Ab2IZQV5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 12:21:57 -0400
Received: by oagh16 with SMTP id h16so756324oag.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2012 09:21:56 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 26 Sep 2012 21:51:56 +0530
Message-ID: <CACuskh++j1QPgvBNhpGmhUOjwozk2vybHq=3_-iSoWaAVxkEvw@mail.gmail.com> (sfid-20120926_182205_985523_765D990A)
Subject: Which tree to pull for submitting patches to net/mac80211
From: kiranaab ki <kiranaab@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

I am all new to linux-open-source and I would like to contribute to
linux-wireless development

I have gone through linux-wireless materials for understanding
the development process from the links below,

 http://www.linuxwireless.org/en/developers/Documentation/git-guide
 http://www.linuxwireless.org/en/developers/Documentation/SubmittingPatches
 http://www.linuxwireless.org/en/developers/process

The above links explain to me the latest development that happens over
wireless-testing.git
I also see in MAINTAINERS list that Johannes Berg maintains two trees
   mac80211.git,
   mac80211-next.git

If I want to send the patches for net/mac80211 and net/cfg8011
do I need to pull wireless-testing.git and send the patches so that
John W Linwille reviews them

     or

do I need to pull mac80211-next.git and send the patches so that
Johannes Berg will review the patches and later John W Linville
pulls the changes from Johannes's tree along the development process ?

Please correct me if my understanding is wrong.

Thanks,
Kiran
