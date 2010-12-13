Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:34607 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906Ab0LMSLD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 13:11:03 -0500
Received: by fxm18 with SMTP id 18so6570700fxm.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 10:11:01 -0800 (PST)
Message-ID: <4D0661CF.7010905@lwfinger.net>
Date: Mon, 13 Dec 2010 12:11:27 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Dave Vasilevsky <dave@vasilevsky.ca>,
	"Luis R. Rodriguez" <mcgrof@kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: compat-wireless-2.6: out of date b43 config option in config.mk
References: <AANLkTin-JwhK_SRhSPrzWJM6fJ9p_rEWVeTLGKk1pyUw@mail.gmail.com> <20101213174321.GB637@tux>
In-Reply-To: <20101213174321.GB637@tux>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/13/2010 11:43 AM, Luis R. Rodriguez wrote:
> On Fri, Dec 10, 2010 at 07:46:16PM -0800, Dave Vasilevsky wrote:
>> Hi Luis,
>>
>> Thanks for your work on compat-wireless, you are officially awesome :)
>>  I just noticed that recent changes in the b43 driver have renamed
>> CONFIG_B43_NPHY to CONFIG_B43_PHY_N, but config.mk in
>> compat-wireless-2.6 is still using the old config option name. Thought
>> I should let you know.
> 
> CONFIG_B43_NPHY is still used, and we have CONFIG_B43_PHY_LP=y as well.
> I don't see any CONFIG_B43_PHY_N on upstream.

It is in wireless-testing since commit 692d2c0fb36c02ad07d54641c26f48e644b27fbd,
dated December 7.

Larry
