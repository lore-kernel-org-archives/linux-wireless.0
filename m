Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f199.google.com ([209.85.210.199]:41725 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbZIRGh7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 02:37:59 -0400
MIME-Version: 1.0
In-Reply-To: <200909151813.32223.IvDoorn@gmail.com>
References: <20090915174233.7db381cd@varda> <200909151813.32223.IvDoorn@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 18 Sep 2009 16:37:43 +1000
Message-ID: <646765f40909172337g74b419fegd2935cb28aedb220@mail.gmail.com>
Subject: Re: [rt2x00] rt2500pci is spamming syslogd since upgrade to 2.6.31
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: =?ISO-8859-1?Q?Alejandro_Riveira_Fern=E1ndez?= <ariveira@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/9/16 Ivo van Doorn <ivdoorn@gmail.com>:
> Hi,
>
>>  Hi; my syslog has many entries like this since the upgrade to 2.6.31
>>
>>  phy0 -> rt2500pci_set_device_state: Error - Device failed to enter state 1 (-16).
>>
>>  Sometimes the driver just start spamming like crazy sometimes is at less rate
>>  sometimes it does not appear.
>>
>>  I'm running 2.6.31 with a revert [1] config follows. If more info is needed
>>  just ask
>>
>>  [1] http://bugzilla.kernel.org/show_bug.cgi?id=13362
>
> Try disabling powersaving,
>
>        iwconfig wlan0 power off

I have an identical problem, which is fixed by this command.

It is possible to detect that the chip doesn't, for whatever reason,
support powersaving and disable it in the driver?

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
