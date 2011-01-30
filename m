Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:57436 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab1A3TJo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 14:09:44 -0500
Message-ID: <4D45B776.4000403@pardus.org.tr>
Date: Sun, 30 Jan 2011 21:09:42 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: Rfkill always soft/hard blocked upon boot
References: <4D455DC1.6010909@pardus.org.tr> <4D45B338.8010802@lwfinger.net>
In-Reply-To: <4D45B338.8010802@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30.01.2011 20:51, Larry Finger wrote:

> The nature of that Fn-F2 key depends on how the motherboard manufacturer coded
> their BIOS. Most do it as a toggle and use some WMI (Windows Management
> Interface) code to initialize it on boot up. As this no-name laptop is unlikely
> to have a WMI driver the way that name brands do, it probably generates a
> keystroke. That is easy to check - Use CTRL-ALT-F1 to switch to a console, log
> in, and issue the command "showkey". Is a keycode returned when Fn-F2 is pressed?

Hmm I've got it. So maybe taking look at the ACPI tables/WMI block can 
reveal a way to initialize the toggle? I'm not really experienced in 
these things but I'll take a look out of curiosity.

Thanks!


-- 
Pardus Linux
http://www.pardus.org.tr/eng
