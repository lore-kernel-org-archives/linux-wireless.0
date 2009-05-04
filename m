Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:56097 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbZEDQfV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 12:35:21 -0400
Subject: Re: [PATCH] add support for showing power constraint IE
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241453408.8683.53.camel@johannes.local>
References: <1241453167-3720-1-git-send-email-marcel@holtmann.org>
	 <1241453408.8683.53.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 04 May 2009 09:35:09 -0700
Message-Id: <1241454909.2903.17.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > +static void print_powerconstraint(const uint8_t type, uint8_t len, const uint8_t *data)
> > +{
> > +	printf(" %d db\n", data[0]);
> 
> s/db/dB/ -- fixed, applied and pushed, thanks.

so how sure are you that you pushed it? I don't see it.

Regards

Marcel


