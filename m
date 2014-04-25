Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:44822 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbaDYIJB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 04:09:01 -0400
Received: by mail-ob0-f169.google.com with SMTP id uz6so3904885obc.14
        for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2014 01:09:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <535A13FA.4070405@gmail.com>
References: <CA+V6dmjwfsrDSDQWHHCFbW9L14GnzifoSjH5UOS4zTSusRtYow@mail.gmail.com>
 <535A13FA.4070405@gmail.com>
From: Pierre Bourdon <delroth@gmail.com>
Date: Fri, 25 Apr 2014 10:08:40 +0200
Message-ID: <CA+V6dmjcYxTjYyjk7kd2-=ijXyqvWL=8bV1YQ0ejeSAK62qapw@mail.gmail.com> (sfid-20140425_100924_579066_DD0AFB1E)
Subject: Re: Odd network behaviors with an Intel Wireless 7260
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Ryan Houdek <sonicadvance1@gmail.com>, tilkax@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[+ another user who reported similar issues]

On Fri, Apr 25, 2014 at 9:51 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> Thank you very much for this very detailed report.
> 1) can you try with power save disabled?
>    sudo iw wlan0 set power_save off

Thanks for the suggestion. I will be testing this over the week-end.
Since this is a random issue (happens every few hours) I will not be
able to be fully certain how much it helps, but I will definitely
notice large improvements / complete mitigations.

FWIW, I've had this issue happen with several 7260 fw versions. Was
uAPSD always advertised as supported or is it an addition of newer
firmwares?

-- 
Pierre "delroth" Bourdon <delroth@gmail.com>
Software Engineer @ Zürich, Switzerland
http://code.delroth.net/
