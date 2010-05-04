Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:51323 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab0EDUoq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 16:44:46 -0400
Received: by pxi5 with SMTP id 5so1124623pxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 May 2010 13:44:46 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 4 May 2010 13:44:26 -0700
Message-ID: <x2q43e72e891005041344gb9945d73p3d97e648fd13aa85@mail.gmail.com>
Subject: A file to print the release of loaded compat-wireless stuff
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems there is a reasonable need to find out what version of
compat-wireless you have running. This will be a dated thing when
based on linux-next but more importantly it will contain the 2.6.3x.y
release the release was based on for the stable releases. Any ideas of
what filesystem API to use for this, I was thinking maybe a simple
sysfs entry for the compat module. Thoughts, preferences?

  Luis
