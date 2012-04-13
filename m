Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s87.loopia.se ([194.9.95.110]:14055 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab2DMPNz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 11:13:55 -0400
Received: from s87.loopia.se (localhost [127.0.0.1])
	by s87.loopia.se (Postfix) with ESMTP id B13671E2C9D5
	for <linux-wireless@vger.kernel.org>; Fri, 13 Apr 2012 17:12:04 +0200 (CEST)
Received: from s87.loopia.se ([127.0.0.1])
	by s87.loopia.se (s87.loopia.se [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id MUZgBTgleymq for <linux-wireless@vger.kernel.org>;
	Fri, 13 Apr 2012 17:12:04 +0200 (CEST)
Received: from s329.loopia.se (s34.loopia.se [194.9.94.70])
	by s87.loopia.se (Postfix) with ESMTP id 77DCB1E2C9CC
	for <linux-wireless@vger.kernel.org>; Fri, 13 Apr 2012 17:12:04 +0200 (CEST)
From: Jan Simonson <jan@simonson.se>
To: Larry Finger <Larry.Finger@lwfinger.net>
Reply-To: Jan Simonson <jan@simonson.se>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: RTL8192e-pci NIC
Date: Fri, 13 Apr 2012 17:11:52 +0200
Message-ID: <3126669.vN7HHIeqdy@ymer> (sfid-20120413_171359_440479_C5F50832)
In-Reply-To: <4F85AB14.4000204@lwfinger.net>
References: <1502184.lhzNHmlX61@ymer> <3893847.nxaiIbI8jN@ymer> <4F85AB14.4000204@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

onsdagen den 11 april 2012 11.02.28 skrev  Larry Finger:
> I copied the kernel source into a separate directory and created a
> stand-alone  build file. All that is working, but I discovered that
> sometime since kernel 3.2, the driver stopped working with my AP that uses
> WPA and 802.11g. The AP's that run 802.11g/WEP and 802.11n/WPA2 are OK. I'm
> bisecting now to find that problem.

Thanks, I'm standing by for information of where I can find your ftp site when 
you are finished working with the driver.

Jan
