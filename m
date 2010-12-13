Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.214.180]:48775 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470Ab0LMST5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 13:19:57 -0500
Received: by iwn37 with SMTP id 37so9683229iwn.11
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 10:19:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D0661CF.7010905@lwfinger.net>
References: <AANLkTin-JwhK_SRhSPrzWJM6fJ9p_rEWVeTLGKk1pyUw@mail.gmail.com>
 <20101213174321.GB637@tux> <4D0661CF.7010905@lwfinger.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 13 Dec 2010 10:19:36 -0800
Message-ID: <AANLkTimCkY_B8V7vj7fbQx0DZLxY+h47ahr8dH0fsPzR@mail.gmail.com>
Subject: Re: compat-wireless-2.6: out of date b43 config option in config.mk
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>,
	"Luis R. Rodriguez" <mcgrof@kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 13, 2010 at 10:11 AM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:
> On 12/13/2010 11:43 AM, Luis R. Rodriguez wrote:
>> On Fri, Dec 10, 2010 at 07:46:16PM -0800, Dave Vasilevsky wrote:
>>> Hi Luis,
>>>
>>> Thanks for your work on compat-wireless, you are officially awesome :)
>>>  I just noticed that recent changes in the b43 driver have renamed
>>> CONFIG_B43_NPHY to CONFIG_B43_PHY_N, but config.mk in
>>> compat-wireless-2.6 is still using the old config option name. Thought
>>> I should let you know.
>>
>> CONFIG_B43_NPHY is still used, and we have CONFIG_B43_PHY_LP=y as well.
>> I don't see any CONFIG_B43_PHY_N on upstream.
>
> It is in wireless-testing since commit 692d2c0fb36c02ad07d54641c26f48e644b27fbd,
> dated December 7.

Anyone care to send me a respective patch for compat-wireless?

  Luis
