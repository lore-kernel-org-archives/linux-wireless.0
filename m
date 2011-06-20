Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40365 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab1FTVzk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 17:55:40 -0400
Received: by gxk21 with SMTP id 21so493611gxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jun 2011 14:55:40 -0700 (PDT)
Message-ID: <4DFFC1D9.8030803@lwfinger.net> (sfid-20110620_235543_762292_A17638B8)
Date: Mon, 20 Jun 2011 16:55:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Peter Chubb <peter@chubb.wattle.id.au>
CC: linux-wireless@vger.kernel.org
Subject: Re: State of rtl8192CU driver?
References: <w4hb7ohfo5.wl%peter@chubb.wattle.id.au>	<4DFB6004.1060006@lwfinger.net> <w44o3l9w74.wl%peter@chubb.wattle.id.au>
In-Reply-To: <w44o3l9w74.wl%peter@chubb.wattle.id.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter,

I found a problem with rtl8192cu since the 3.0-rcX merge. Please go to 
https://bugzilla.kernel.org/show_bug.cgi?id=38012 and try the patch found there.

Please let me know if it fixes your problem.

Larry
