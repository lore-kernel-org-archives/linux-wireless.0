Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38313 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab2JLGxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 02:53:14 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so1859975lbo.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2012 23:53:12 -0700 (PDT)
Message-ID: <5077BE43.7050200@gmail.com> (sfid-20121012_085319_585069_E106F6D6)
Date: Fri, 12 Oct 2012 08:52:51 +0200
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-wireless@vger.kernel.org, hch@lst.de, s.L-H@gmx.de,
	linville@tuxdriver.com
Subject: Re: [PATCH 0/4] Driver for the ar5523 chipset
References: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com> <20121011203112.GB3317@kroah.com>
In-Reply-To: <20121011203112.GB3317@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> But what is keeping this driver from going to the "proper" place in the
> kernel tree (i.e. drivers/net/...)?  I don't have a problem adding it to
> the staging tree, but it would need a TODO file to list what is needed
> to get it out of the staging tree.

I couldn't decide myself so I asked John and he suggested staging. 
Perhaps it should be in driver/net/wireless after all. Can you and John 
give some advice?

Here's a list of things to consider:

* The FW API is reverse engineered and no real documentation is available.
* Limited functionality (notably no HW crypto offload).
* I'm committed to maintaining the driver and fix problems, but only as 
a hobbist.
* It has received very limited testing. S L-H is the only one except 
myself that has run it.

Cheers,

Pontus
