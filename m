Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:38619 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965021Ab1GMKuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 06:50:23 -0400
Message-ID: <4E1D7866.3020302@adurom.com> (sfid-20110713_125027_293212_ADF54352)
Date: Wed, 13 Jul 2011 13:50:14 +0300
From: Kalle Valo <kvalo@adurom.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [TODO] at76c50x: remove wext includes
References: <1310546836.3873.6.camel@jlt3.sipsolutions.net> <4E1D5CB7.7070607@adurom.com> <CAGRGNgWC21fLzsm4rb_nOb8AraaZiXUjXwUGhPrAzoLLMhwSEw@mail.gmail.com>
In-Reply-To: <CAGRGNgWC21fLzsm4rb_nOb8AraaZiXUjXwUGhPrAzoLLMhwSEw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2011 01:35 PM, Julian Calaby wrote:
> On Wed, Jul 13, 2011 at 18:52, Kalle Valo <kvalo@adurom.com> wrote:
>> The driver has been broken due to the mac80211 changes for a long time
>> and it's obvious that I can't maintain it anymore as I haven't touched
>> it for a long time. I would like to just remove it altogether. Any
>> objections?
> 
> What hardware is it for?

For USB devices from stone age which had Atmel at76c50x chipset. For
example Belkin F5D5060 was one of them:

http://www.gearxs.com/gearxs/product_info.php?products_id=3535

Kalle
