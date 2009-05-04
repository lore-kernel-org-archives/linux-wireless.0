Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:59103 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbZEDQ3K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 12:29:10 -0400
Subject: Re: [PATCH] add basic support for parsing country information
 element
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241453862.8683.59.camel@johannes.local>
References: <1241413787-3185-1-git-send-email-marcel@holtmann.org>
	 <1241423772.8683.8.camel@johannes.local>
	 <1241423924.8683.9.camel@johannes.local>
	 <1241427107.2899.9.camel@localhost.localdomain>
	 <1241435567.8683.35.camel@johannes.local>
	 <1241437035.8683.37.camel@johannes.local>
	 <1241452364.2903.3.camel@localhost.localdomain>
	 <1241452664.8683.51.camel@johannes.local>
	 <1241453361.2903.15.camel@localhost.localdomain>
	 <1241453862.8683.59.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 04 May 2009 09:28:58 -0700
Message-Id: <1241454538.2903.16.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > On a different note, what is your preferred coding style for loops?
> > 
> > 	for (i = 0; i < len; i++) {
> > 
> > or
> > 
> > 	for(i=0; i<len-3; i++)
> > 
> > I was using the latter one since I assumed that is what you want (it is
> > not my preferred one). Then I realized that you are using both or that
> > something slipped in. Do you want me to send a patch to fix this?
> 
> Oh, well, I prefer the former, but some other people put in the latter,
> and I didn't really care too much. No need to send a patch though.

I will sent a patch since I prefer the former too, but assumed you liked
that latter one and that was my mistake in cluttering the code with more
mixed coding style than needed.

Regards

Marcel


