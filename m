Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f49.google.com ([209.85.212.49]:63202 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab3HBEjQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 00:39:16 -0400
Received: by mail-vb0-f49.google.com with SMTP id w16so174186vbb.8
        for <linux-wireless@vger.kernel.org>; Thu, 01 Aug 2013 21:39:15 -0700 (PDT)
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 1 Aug 2013 21:38:55 -0700
Message-ID: <CALCETrW6BrCFHjALQVexUy61=f5QXOjiHhvRNGqnN--iZei+RQ@mail.gmail.com> (sfid-20130802_063920_036931_AFA9C3F3)
Subject: [3.11 regression?] iwlwifi firmware takes two minutes to load
To: Linux Wireless List <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At boot, I get:
[   12.537108] iwlwifi 0000:03:00.0: irq 51 for MSI/MSI-X
...
[  132.676781] iwlwifi 0000:03:00.0: loaded firmware version 9.221.4.1
build 25532 op_mode iwldvm

This sounds familiar, but wasn't it fixed awhile ago?

--Andy
