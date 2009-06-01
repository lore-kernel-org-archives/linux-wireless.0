Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:29286 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbZFADIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 23:08:17 -0400
Received: by yw-out-2324.google.com with SMTP id 5so4161913ywb.1
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2009 20:08:18 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 1 Jun 2009 00:08:17 -0300
Message-ID: <ee8eb53d0905312008rbd346d8h171fedb96d2a3d96@mail.gmail.com>
Subject: [GSoC 2009] Automation of testing using mac80211_hwsim and Orbit -
	status report 01
From: Georgy Berdyshev <codingmaster@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Automation of testing using mac80211_hwsim and Orbit

Hello Linux wireless users and kernel developers, Luis, John and Johannes,

this is the first status report of the "Automation of testing using
mac80211_hwsim and Orbit",
which is kindly sponsored by Google in the Summer of Code program and
mentored by the Linux Foundation.

http://www.linuxwireless.org/en/developers/GSoC/2009/Automation_of_testing
http://socghop.appspot.com/student_project/show/google/gsoc2009/linux_foundation/t124022664044

In the first week, I did implement a ground base for the testing
command line tool, which is written
in Python and will create statistics from the test set and later on
collect them and provide nice
statistics.

The installer, some basic commands and the parser are finished and I
did translate some of the available
tests (link from Luis) to Python. Moreover I have concentrated on
creating new tests and adding the loading
of kernel modules and setting options to the program.

By the end of the week, I did start to have some strange problems with
running hostapd (via nl80211) and using the
mac80211_hwsim kernel driver.

In case that someone did run into that problem with 2.6.30-rc5,6,7 +
latest git and latest git of hostap / wpa_supplicant,
it would be great to have a feedback on that.

One of the first tasks for the new week will be the creation of a wiki
documentation and also an introduction
how to check out the code, run some tests locally and also send
feedbacks / bug reports.
Like planned, I will continue to extend the test scenario by adding
more tests and also functionality to the command
line test tool.


Thanks, Georgy

-- 
Georgy Berdyshev

GPG key: 830F68C5
Fingerprint: 0379 ED5A BEE5 65A8 7BD5  31E7 F5B4 1EC7 830F 68C5
