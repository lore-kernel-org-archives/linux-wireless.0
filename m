Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:34284 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbZIAQhr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 12:37:47 -0400
Received: by bwz19 with SMTP id 19so112414bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 09:37:48 -0700 (PDT)
Message-ID: <4A9D4DD8.5020300@lwfinger.net>
Date: Tue, 01 Sep 2009 11:37:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Tobias Schlemmer <keinstein_junior@gmx.net>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8187b Problem with tx level
References: <h7eo7q$7ks$1@ger.gmane.org>	 <3ace41890908311055s5c49a25fjf69ca48024579d44@mail.gmail.com>	 <43e72e890908311102q2ed9e8b3q8f1f15d45a29b2f1@mail.gmail.com>	 <3ace41890908311132g16783b68y2d1771ce1d2780d@mail.gmail.com>	 <43e72e890908311141k6bcf5edbl6bce2b88670fb5f8@mail.gmail.com>	 <3ace41890908311157v4fbc9829j6db9c91ef6fff3c7@mail.gmail.com>	 <4A9C3C59.5010305@lwfinger.net>	 <69e28c910908311418l7f033b5bp7a9b443cd253304@mail.gmail.com>	 <4A9C42C5.6050400@lwfinger.net> <3ace41890908311616k4040d59fub051d21e822604d0@mail.gmail.com>
In-Reply-To: <3ace41890908311616k4040d59fub051d21e822604d0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> 
> The r8187 is distributed from OEMs - stand to reason, as realtek don't
> really sell their own brand on high-street shops? We got one release
> e-mailed to us, and there are a few floating around on the internet
> under some laptop or usb hardware vendors. It is available under this,
> for example: http://service.one.de/index.php?&direction=0&order=&directory=NOTEBOOKS/ONE_A1XX/LINUX/Source-code/Wireless
> r8187mesh is the one in the mesh directory.

Thanks for this link. I got this code and I am in the process of
comparing it with the current rtl8187. So far, I find that the code
that sets the TX power levels is identical with ours.

Larry



