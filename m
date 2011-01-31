Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:35776 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab1AaLEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 06:04:42 -0500
Message-ID: <4D46974A.3080802@pardus.org.tr>
Date: Mon, 31 Jan 2011 13:04:42 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: Joey Lee <jlee@novell.com>
CC: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	platform-driver-x86@vger.kernel.org
Subject: Re: Rfkill always soft/hard blocked upon boot
References: <4D455DC1.6010909@pardus.org.tr> <4D45B338.8010802@lwfinger.net> <4D45B776.4000403@pardus.org.tr> <4D46B4340200002300027E82@novprvlin0050.provo.novell.com> <4D467AFC.7090503@pardus.org.tr> <4D4727E10200002300027EDF@novprvlin0050.provo.novell.com>
In-Reply-To: <4D4727E10200002300027EDF@novprvlin0050.provo.novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31.01.2011 12:21, Joey Lee wrote:
> Hi Oza,

>
> Sorry, I am not good for this platform, but will check your DSDT.

I dumped the _WDG block and find out that the GUIDs are exactly same 
with the following driver posted on Dec'2010 but not merged to upstream yet:

http://www.spinics.net/lists/platform-driver-x86/msg01075.html

I don't know if that driver will help in anything. I've asked the user 
if its other hotkeys are working or not.


-- 
Pardus Linux
http://www.pardus.org.tr/eng
