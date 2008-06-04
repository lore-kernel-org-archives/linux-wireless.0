Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from po-out-1718.google.com ([72.14.252.154]:65034 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbYFDTJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 15:09:40 -0400
Received: by po-out-1718.google.com with SMTP id c31so421036poi.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2008 12:09:37 -0700 (PDT)
Message-ID: <1ba2fa240806041209i5e3fbb35r5667314ea9417379@mail.gmail.com> (sfid-20080604_210943_755305_34172CC1)
Date: Wed, 4 Jun 2008 22:09:37 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Lukas Hejtmanek" <xhejtman@ics.muni.cz>
Subject: Re: Page allocation failure in 2.6.26-rc2 (iwl4965 driver)
Cc: "maximilian attems" <max@stro.at>, linux-mm@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080604185743.GQ5012@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080604130307.GN5012@ics.muni.cz>
	 <20080604130452.GD9258@baikonur.stro.at>
	 <20080604185743.GQ5012@ics.muni.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/6/4 Lukas Hejtmanek <xhejtman@ics.muni.cz>:
> On Wed, Jun 04, 2008 at 03:04:52PM +0200, maximilian attems wrote:
>> similar with 2.6.25-rc3-git7 not a regression. happens for me since
>> early merge of iwlwifi after several resume and suspend cycles + mem
>> pressure.
>
> Jiri Slaby suggested that the iwl driver should not try to alloc 64kB (order
> 4) using kalloc but vmalloc should be used instead. While not understanding
> iwl driver internals, I cannot say whether it can be replaced per se.
>

We my try it but the problem is somewhere else.
Tomas
