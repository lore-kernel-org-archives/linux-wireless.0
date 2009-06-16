Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f211.google.com ([209.85.220.211]:58520 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZFPCoO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 22:44:14 -0400
Received: by fxm7 with SMTP id 7so333751fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2009 19:44:15 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 16 Jun 2009 03:36:51 +0100
Message-ID: <3ace41890906151936s3f0d70fcx6f42bfddf07dd70e@mail.gmail.com>
Subject: vid/pid sorting patch? (Re: [PATCH] zd1211rw: adding 083a:e503 as a
	ZD1211B device)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hiya,

The zd1211rw vid/pid list is getting a bit unruly - would it be
acceptable to submit a non-code-changing patch just to sort the ids?
It would just be tidier and make it easier to see what id is already
in and what is not, and also make it obvious where new changes should
be inserted. I know this affects git blame and other log searching
usage so may not be entirely desirable.

Hin-Tak
