Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58976 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab2JPUFr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 16:05:47 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so4543280lbo.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2012 13:05:45 -0700 (PDT)
Date: Tue, 16 Oct 2012 23:10:11 +0300
From: Eugene <wifi.mailing.list@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: mac80211 without data path?
Message-ID: <20121016231011.2b13db64@gmail.com> (sfid-20121016_220558_153923_8FB5C04F)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everybody,

I'm a new one in Linux wireless and want to know.
Is it possible to use mac80211 without Data Path, just handle
management frames.

I see that a lot of features integrated in to the data path (PS,
Statistic,...). Some of them looks like can be disabled by
capabilities.

I'm just thinking to reuse authentication and association services.

Maybe exists some document with description about each feature and
its requirements for the vendor driver?

Or that is completely wrong way?
