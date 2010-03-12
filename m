Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f198.google.com ([209.85.216.198]:53298 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab0CLBUH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 20:20:07 -0500
Received: by pxi36 with SMTP id 36so230737pxi.21
        for <linux-wireless@vger.kernel.org>; Thu, 11 Mar 2010 17:20:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1268355918.22460.3.camel@mj>
References: <1268343167-2961-1-git-send-email-hauke@hauke-m.de>
	<1268343167-2961-5-git-send-email-hauke@hauke-m.de> <1268355918.22460.3.camel@mj>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 11 Mar 2010 17:19:47 -0800
Message-ID: <43e72e891003111719t5b8f5386p155ea80ae2112655@mail.gmail.com>
Subject: Re: [PATCH 2/5] compat-wireless: add orinoco to compat-wireless
To: Pavel Roskin <proski@gnu.org>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 11, 2010 at 5:05 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Thu, 2010-03-11 at 22:32 +0100, Hauke Mehrtens wrote:
>> orinoco now depends on cfg80211. If compat-wireless was installed it
>> will install its own version of cfg80211 and orinoco will not work any
>> more because it wants to use the version shipped with the kernel.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>
> If orinoco is in compat-wireless and hostap is not, I'm concerned that
> users with hostap would end up with a less capable orinoco driver.

Curious, is anyone planning on porting hostap to cfg80211?

Our todo list for conversion lists it as having a partial conversion:

http://wireless.kernel.org/en/developers/todo-list/cfg80211-conversion

Who is doing such conversion? I don't see anything on wireless-testing for this.

> I'm going to make a patch that would disable support for Prism chipset
> in Orinoco by default.  It should have been done long ago, but I never
> had a chance, and patches proposed by others had quality issues.

Great.

  Luis
