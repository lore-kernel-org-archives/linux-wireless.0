Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:37149 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142Ab0HJMn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 08:43:58 -0400
Message-ID: <4C614988.20106@adurom.com>
Date: Tue, 10 Aug 2010 15:43:52 +0300
From: Kalle Valo <kvalo@adurom.com>
MIME-Version: 1.0
To: Ameya Palande <ameya.palande@nokia.com>
CC: linux-wireless@vger.kernel.org, carsten@maemo.org
Subject: Re: bug: wl1251 stalls connection
References: <1281438628.1964.6.camel@chotu>
In-Reply-To: <1281438628.1964.6.camel@chotu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/10/2010 02:10 PM, Ameya Palande wrote:
> Hi,

Hi Ameya,

> Can you guys have a look at following wl1251 bug?

I'll plan to look at later this week. I need to first setup my n900 to
work with the latest upstream kernel.

> Bug 5030 - WL1251 stalls connection completely when being asked to scan 
> while associated
> 
> Link: http://bugs.meego.com/show_bug.cgi?id=5030

I remember Android having similar problems with wl1251_sdio. I'm
guessing wl1251 scan commands are somehow broken in upstream kernel.
Obviously this was working with maemo kernels.

It would help someone can file a bug about this to
https://bugzilla.kernel.org/. Easier to track the issue that way.

Kalle
