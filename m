Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39976 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbbAMF7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 00:59:13 -0500
Date: Mon, 12 Jan 2015 19:32:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/6] staging: vt6655: set_channel replace parameter with
 ieee80211_channel
Message-ID: <20150113033219.GA31093@kroah.com> (sfid-20150113_065917_166312_B03FE7B7)
References: <1417731167-3231-1-git-send-email-tvboxspy@gmail.com>
 <54920EDC.4090007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54920EDC.4090007@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 17, 2014 at 11:16:44PM +0000, Malcolm Priestley wrote:
> 
> 
> On 04/12/14 22:12, Malcolm Priestley wrote:
> >replacing uConnectionChannel for hw_value as set in vnt_init_bands.
> >
> >This allows other signaling of ieee80211_channel to move deeper into
> >driver.
> >
> >Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> >---
> Hi greg
> 
> Can you drop this patch series altogether.
> 
> I will repost these later after some needed bug fixes for 3.19

Now dropped.
