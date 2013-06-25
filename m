Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:36778 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab3FYUtS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 16:49:18 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: pull request: bluetooth 2013-06-23
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20130625201217.GA13879@amd.pavel.ucw.cz>
Date: Tue, 25 Jun 2013 13:49:19 -0700
Cc: Gustavo Padovan <gustavo@padovan.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Message-Id: <E95EC814-F064-4AEB-AE13-79982D3BE5E8@holtmann.org> (sfid-20130625_224935_184301_A9287FCB)
References: <20130623021351.GA2327@joana> <20130625201217.GA13879@amd.pavel.ucw.cz>
To: Pavel Machek <pavel@ucw.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pavel,

>> Jaganath Kanakkassery (1):
>>      Bluetooth: Fix invalid length check in l2cap_information_rsp()
> 
> Could we add the "3.10 vs. thinkpad x60" patch that fixes regression?
> It is from Johan Hedberg…

that one went into net-next tree. It is scheduled for 3.11 right now.

After 3.10 is out, maybe it can go into -stable, but otherwise I think it is bit late now. Unless someone wants to cherry-pick it.

Regards

Marcel

