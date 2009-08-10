Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:59590 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbZHJMtw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 08:49:52 -0400
Received: by fxm28 with SMTP id 28so884762fxm.17
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 05:49:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200908101441.43480.mb@bu3sch.de>
References: <4A7F713E.8040405@gmail.com> <200908101441.43480.mb@bu3sch.de>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 10 Aug 2009 14:49:31 +0200
Message-ID: <69e28c910908100549w6af5bd12j568c7f0c2aa31e30@mail.gmail.com>
Subject: Re: [RFC PATCH] b43: Implement LP-PHY baseband table initialization
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/10 Michael Buesch <mb@bu3sch.de>:
> On Monday 10 August 2009 03:00:46 Gábor Stefanik wrote:
>> +static const u16 lpphy_sw_control_table[] = {
>> +     0x0128,
>> +     0x0128,
>> +     0x0009,
>> +     0x0009,
>> +     0x0028,
>> +     0x0028,
>
> Is it possible to use more than one value per line for all these tables?
> Make sure to make best use of the 80 columns limit.
> This would significantly decrease the patch/file length. (linewise)
>
> --
> Greetings, Michael.
>

Well, I converted the tables directly from the Wikitext on
bcm-v4.sipsolutions.net using regex search&replace - if you know a
good regex to convert the tables to use multiple values on each line,
please post it.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
