Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.191]:45809 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454AbYASDvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 22:51:11 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1079875rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jan 2008 19:51:08 -0800 (PST)
Message-ID: <e6493e6a0801181951l2b57af9ar694dab8774838449@mail.gmail.com> (sfid-20080119_035116_811619_6CB9B688)
Date: Fri, 18 Jan 2008 21:51:08 -0600
From: "jared camarata" <gkjared@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: bug in makefile
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a problem in the make file of compat-wireless on ubuntu.
$(PWD) is defined at '/' instead of /my/current/location/
It's causing this error: Makefile:19: /config.mk: No such file or  directory.
When i use it as a user (none-sudo), it finds the file just fine.
The line is include $(PWD)/$(COMPAT_CONFIG)


Thanks,
Jared
