Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:21994 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYFEIyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 04:54:37 -0400
Received: by rv-out-0506.google.com with SMTP id l9so603779rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2008 01:54:36 -0700 (PDT)
Message-ID: <1ba2fa240806050154w6bee2f08n80031e09ac12e9ed@mail.gmail.com> (sfid-20080605_105441_182074_EE595416)
Date: Thu, 5 Jun 2008 11:54:36 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Lukas Hejtmanek" <xhejtman@ics.muni.cz>
Subject: Re: Page allocation failure in 2.6.26-rc2 (iwl4965 driver)
Cc: "maximilian attems" <max@stro.at>, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240806041209i5e3fbb35r5667314ea9417379@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080604130307.GN5012@ics.muni.cz>
	 <20080604130452.GD9258@baikonur.stro.at>
	 <20080604185743.GQ5012@ics.muni.cz>
	 <1ba2fa240806041209i5e3fbb35r5667314ea9417379@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 4, 2008 at 10:09 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> 2008/6/4 Lukas Hejtmanek <xhejtman@ics.muni.cz>:
>> On Wed, Jun 04, 2008 at 03:04:52PM +0200, maximilian attems wrote:
>>> similar with 2.6.25-rc3-git7 not a regression. happens for me since
>>> early merge of iwlwifi after several resume and suspend cycles + mem
>>> pressure.
>>
>> Jiri Slaby suggested that the iwl driver should not try to alloc 64kB (order
>> 4) using kalloc but vmalloc should be used instead. While not understanding
>> iwl driver internals, I cannot say whether it can be replaced per se.
>>
>
> We my try it but the problem is somewhere else.

Actually I've already posted the patch that fixes allocation. It' just
not in rc2
http://marc.info/?l=linux-wireless&m=121205035427353&w=2

Tomas
