Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:42671 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2KMR2t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 12:28:49 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so10386eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 09:28:48 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
	linux-wireless@vger.kernel.org
Subject: staging: rtl8187se: code cleanups
Date: Tue, 13 Nov 2012 19:28:06 +0200
Message-Id: <1352827703-4659-1-git-send-email-maxtram95@gmail.com> (sfid-20121113_182853_789195_DD5C559B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are some bug fixes, cleanups and dead code removal for
drivers/staging/rtl8187se

Some of the patches don't pass checkpatch.pl. That's because original code did not follow kernel coding style and I've made small changes to that bad lines. I haven't done new coding style violations.

