Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:34454 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718AbZBQAMY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 19:12:24 -0500
Message-ID: <499A00D7.1080000@lwfinger.net> (sfid-20090217_011227_992325_9511F51F)
Date: Mon, 16 Feb 2009 18:12:07 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	viktor.ilijasic@gmail.com
Subject: Re: rtl8187 not handling my usb card
References: <4999F3A6.7020208@gmail.com> <4999F427.4060008@lwfinger.net> <3ace41890902161603o447ae321obb536586dcafad69@mail.gmail.com>
In-Reply-To: <3ace41890902161603o447ae321obb536586dcafad69@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> Hiya,
> 
> A quick search on google shows Airlive hosting a linux driver here:
> 
> http://www.airlive.com/support/support_3a.jsp?pdid=PD1223473034861
> 
> I had a quick look  and indeed it looks like the realtek vendor driver
> (or a variant of) for 8187L.
> Note that this is for reference, since we all know the vendor driver
> has some issues with the latest wireless stack, etc.

Once I get confirmation from the OP that his device works, I have a patch with a
total of 6 new ID's for rtl8187. Four of them came from the .inf file
accompaning the Windows version of the RTL8187L driver.

Larry
