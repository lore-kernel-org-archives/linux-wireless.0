Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:38312 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab0HJNfu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 09:35:50 -0400
Subject: Re: bug: wl1251 stalls connection
From: Ameya Palande <ameya.palande@nokia.com>
To: ext Kalle Valo <kvalo@adurom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"carsten@maemo.org" <carsten@maemo.org>
In-Reply-To: <4C614988.20106@adurom.com>
References: <1281438628.1964.6.camel@chotu>  <4C614988.20106@adurom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Aug 2010 16:35:17 +0300
Message-ID: <1281447317.17541.30.camel@chotu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Tue, 2010-08-10 at 14:43 +0200, ext Kalle Valo wrote:
> On 08/10/2010 02:10 PM, Ameya Palande wrote:
> > Hi,
> 
> Hi Ameya,
> 
> > Can you guys have a look at following wl1251 bug?
> 
> I'll plan to look at later this week. I need to first setup my n900 to
> work with the latest upstream kernel.
> 
> > Bug 5030 - WL1251 stalls connection completely when being asked to scan 
> > while associated
> > 
> > Link: http://bugs.meego.com/show_bug.cgi?id=5030
> 
> I remember Android having similar problems with wl1251_sdio. I'm
> guessing wl1251 scan commands are somehow broken in upstream kernel.
> Obviously this was working with maemo kernels.
> 
> It would help someone can file a bug about this to
> https://bugzilla.kernel.org/. Easier to track the issue that way.

https://bugzilla.kernel.org/show_bug.cgi?id=16554

Cheers,
Ameya.

