Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41390 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267AbcA2JIe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 04:08:34 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Joe Qiao <qlnaaa@gmail.com>
Cc: Linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: how to kick off wifi user
References: <CALUcjaOWy=T+Xw7hvi05LHRa8N2zvEvhB=TjOhan-xdirMBXxA@mail.gmail.com>
Date: Fri, 29 Jan 2016 11:08:30 +0200
In-Reply-To: <CALUcjaOWy=T+Xw7hvi05LHRa8N2zvEvhB=TjOhan-xdirMBXxA@mail.gmail.com>
	(Joe Qiao's message of "Fri, 29 Jan 2016 10:26:04 +0800")
Message-ID: <87d1sku50x.fsf@purkki.adurom.net> (sfid-20160129_100841_845304_A08D9B18)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Qiao <qlnaaa@gmail.com> writes:

> Now I setup AP and want to find a way to kick off a special wifi user
> from the AP. I know “iw dev station del”, but it seems it only remove
> the station data from driver inside, but cannot trigger a
> disassociation frame wireless client. Would you please give some
> guidance about kick off wifi user?

You can do that with hostapd_cli deauthenticate command. But please use
google first, it took 15 seconds to find this:

http://stackoverflow.com/questions/19400117/disconnect-user-on-hostap

-- 
Kalle Valo
