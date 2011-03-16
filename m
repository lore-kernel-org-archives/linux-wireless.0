Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61993 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab1CPWsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 18:48:06 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 16 Mar 2011 15:47:45 -0700
Message-ID: <AANLkTimmzYbAHobz-NtwHoGZpgOZBbLb1MbUpSb_8Jbp@mail.gmail.com>
Subject: Cherry picking patches made easy for stable compat-wireless
To: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So, sometimes some patches going upstream are not "stable" candidates
but yet can help considerably. If you are writing such a patch I would
like to ask for you to append to your commit log entry this:

Cc: compat@orbit-lab.org

I will then scrape linux-next.git for these patches and stuff them
into linux-next-cherry-pick/ for integration into a non-vanilla
release of a stable compat-wireless. John, please let me know if this
one line commit log pollution acceptable to you.

  Luis
