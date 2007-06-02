Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:19848 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbXFBSly (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jun 2007 14:41:54 -0400
Received: by mu-out-0910.google.com with SMTP id i10so1156570mue
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jun 2007 11:41:53 -0700 (PDT)
Message-ID: <7b4bf7ff0706021141g35c6e978m85988f5114ff81a9@mail.gmail.com>
Date: Sat, 2 Jun 2007 20:41:53 +0200
From: "Olivier Cornu" <o.cornu@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH] mac80211: Update stop_queues kdoc
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200706021537.58602.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <200706011129.12432.mb@bu3sch.de> <200706012342.20592.mb@bu3sch.de>
	 <7b4bf7ff0706020617l4cf50359g8358e4aa2b359999@mail.gmail.com>
	 <200706021537.58602.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/6/2, Michael Buesch <mb@bu3sch.de>:
> On Saturday 02 June 2007 15:17:55 Olivier Cornu wrote:
> > Is there any way to tell mac80211 the device is in a [temporary]
> > "non-functional" state (reset, association loss...) ?
>
> As far as I can see ieee80211_stop_queues() is exactly for that, but
> it's broken.

_If_ it is so, then stop_queues is misnamed.
In its current form, stop_queues suggests to driver writers it is just
a shortcut to save them looping through each queue to stop them all.

--
Olivier Cornu
