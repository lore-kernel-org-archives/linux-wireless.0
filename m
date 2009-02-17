Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:38859 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbZBQADk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 19:03:40 -0500
Received: by bwz5 with SMTP id 5so3524962bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2009 16:03:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4999F427.4060008@lwfinger.net>
References: <4999F3A6.7020208@gmail.com> <4999F427.4060008@lwfinger.net>
Date: Tue, 17 Feb 2009 00:03:38 +0000
Message-ID: <3ace41890902161603o447ae321obb536586dcafad69@mail.gmail.com> (sfid-20090217_010345_020703_2C91A891)
Subject: Re: rtl8187 not handling my usb card
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	viktor.ilijasic@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hiya,

A quick search on google shows Airlive hosting a linux driver here:

http://www.airlive.com/support/support_3a.jsp?pdid=PD1223473034861

I had a quick look  and indeed it looks like the realtek vendor driver
(or a variant of) for 8187L.
Note that this is for reference, since we all know the vendor driver
has some issues with the latest wireless stack, etc.
