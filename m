Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44121 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab0I3QPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 12:15:42 -0400
Received: by fxm4 with SMTP id 4so852876fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 09:15:37 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Joshua Smith <JoshuaESmith@charter.net>
Subject: Re: Question about starting up an AP
Date: Thu, 30 Sep 2010 18:14:47 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com, Ivo van Doorn <ivdoorn@gmail.com>
References: <DA0C92FD-F6BF-4746-9BE1-A643A0D70F7A@kaon.com> <C4D5DF09-82F0-48B4-9D64-6621B3C82932@kaon.com> <71135D34-18F6-4909-A8AB-E7390FA73049@charter.net>
In-Reply-To: <71135D34-18F6-4909-A8AB-E7390FA73049@charter.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201009301814.47318.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag 30 September 2010 schrieb Joshua Smith:
> I think I have a clue about the WPDMA TX/RX busy bug.  I was having trouble
> using the latest compat-wireless with USB dongle I have (ID AB50:2019
> rt73usb), so I tried rolling Helmut's "oops" fix into:
> 
> compat-wireless-2010-07-15
> 
> which I have been using successfully for the last few months.  Lo and behold,
> this version does *NOT* exhibit the TX/RX busy error.  So whatever is causing
> that problem was introduced between 7/15/2010 and 9/20/2010.

Thanks for the analysis Joshua! Since this is a regression I guess we
should try to find out quickly which commit introduced it (and fix it up
of course) ...

Helmut


