Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:37648 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbYKTQPG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 11:15:06 -0500
Subject: Re: [PATCH] wireless: sysfs was displaying different values for
	level and noise than procfs
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Andrey Borzenkov <arvidjaar@mail.ru>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1227164258.17336.20.camel@johannes.berg>
References: <200811151831.26403.arvidjaar@mail.ru>
	 <1227122019.2196.14.camel@dv> <200811192245.29487.arvidjaar@mail.ru>
	 <20081119200856.GH3485@tuxdriver.com>  <1227131518.3571.16.camel@dv>
	 (sfid-20081119_225207_085809_144B09A0)  <1227164258.17336.20.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 20 Nov 2008 11:15:01 -0500
Message-Id: <1227197701.10629.1.camel@dv> (sfid-20081120_171511_568385_B0ED8569)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-11-20 at 07:57 +0100, Johannes Berg wrote:

> Actually, I was hoping to deprecate the sysfs interface, there are tons
> of apps relying on procfs unfortunately and very few, if any, relying on
> sysfs.

OK, then I would not bother changing it at all.

-- 
Regards,
Pavel Roskin
