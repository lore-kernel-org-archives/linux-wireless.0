Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.181]:43913 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbYBNJtg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 04:49:36 -0500
Received: by el-out-1112.google.com with SMTP id v27so319314ele.23
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2008 01:49:35 -0800 (PST)
Message-ID: <a32f33a40802140149w48a1ee51idf4a7fd0619879f3@mail.gmail.com> (sfid-20080214_094941_719681_DA7C3A70)
Date: Thu, 14 Feb 2008 10:49:34 +0100
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Adam Turk" <bofh1234@hotmail.com>
Subject: Re: kernel 2.6.25-rc1 and no /dev/rt73usb
Cc: "Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <BAY101-W1421BB30E73369FE0A2E3DC8250@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <BAY101-W101597BA2B1DDD58D6F497C8250@phx.gbl>
	 <1202952347.29519.5.camel@dv>
	 <BAY101-W1421BB30E73369FE0A2E3DC8250@phx.gbl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>  phy0: Failed to initialize wep

I see this message popping up more frequently lately.

Do any of the mac80211 people know when and why mac80211
fails to load the wep module?
Is there some dependency missing for mac80211?

Ivo
