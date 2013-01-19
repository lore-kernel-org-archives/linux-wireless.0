Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:41941 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3ASSWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jan 2013 13:22:44 -0500
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Sat, 19 Jan 2013 10:22:22 -0800
Message-ID: <CAB=NE6VY8pkNwZfx0HiAXRvx+RuXJpVByX7LSj2VTYdaMv9z_w@mail.gmail.com> (sfid-20130119_192300_747451_34F88358)
Subject: [ANN] rel-html HTML5 release page generator for Linux and friends
To: linux-kernel@vger.kernel.org, backports@vger.kernel.org
Cc: Konstantin Ryabitsev <mricon@kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I had to write an HTML5 release page generator [0] for compat-drivers
[1] for its new shiny new home page on kernel.org. While working on it
I got a feature request to try to support any project, so I
generalized the tool for any FOSS project. It currently supports
parsing releases for the Linux kernel, compat-drivers, iw, crda,
hostapd should any of these projects like it for its releases page.
I'm happy to make the tool's first release now that it actually infers
releases so there is no need to update the project configuration file
when a new release is made, it will infer releases based on some
supplied hints and naked index release URLs.

Example output of what releases look like:

http://drvbp1.linux-foundation.org/~mcgrof/rel-html/

Patches / feedback welcomed.

[0] git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/rel-html.git
[1] https://backports.wiki.kernel.org/

  Luis
