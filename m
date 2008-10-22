Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53197 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbYJVOaI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 10:30:08 -0400
Subject: Re: Marvell TopDog Driver Work
From: Dan Williams <dcbw@redhat.com>
To: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1224631576.6873.40.camel@the-omnibook>
References: <48A5DBAB.9080405@erley.org> <20080815195825.GD5935@tesla>
	 <1218830917.14841.20.camel@localhost.localdomain>
	 <gdidhg$hdq$3@ger.gmane.org>
	 <1224524168.29822.46.camel@dhcp-100-3-195.bos.redhat.com>
	 <1224525810.6873.8.camel@the-omnibook>
	 <43e72e890810201245t3ac18fd6taf229af88350958f@mail.gmail.com>
	 <1224533105.6873.22.camel@the-omnibook>
	 <1224595093.24581.15.camel@localhost.localdomain>
	 <1224631003.6873.39.camel@the-omnibook>
	 <1224631576.6873.40.camel@the-omnibook>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 10:28:49 -0400
Message-Id: <1224685729.3987.1.camel@dhcp-100-3-195.bos.redhat.com> (sfid-20081022_163013_787303_D041A18C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-10-21 at 16:26 -0700, Daniel Gimpelevich wrote:
> On Tue, 2008-10-21 at 16:16 -0700, Daniel Gimpelevich wrote:
> > 1) Use the in-tree libertas library to get b/g going for 8335/8310
> > parts, using mrv8k/malo as a guide.
> 
> Never mind; I just noticed that the code is FullMAC. Ick.

It's not all that icky, actually :)  But yes, the current libertas
driver is for the fullmac parts, while 8310, 8335, 8361, and 8362 are
softmac parts.

Dan


