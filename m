Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42118 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbZEGNQK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2009 09:16:10 -0400
Date: Thu, 7 May 2009 09:14:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Hans Maes <Hans@bitnet.be>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath5k antenna control patch
Message-ID: <20090507131444.GA16718@tuxdriver.com>
References: <4A029F31.6090405@bitnet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A029F31.6090405@bitnet.be>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 07, 2009 at 10:43:29AM +0200, Hans Maes wrote:
> Hello,
>
> Could somebody tell me if there is any reason why the patch implementing  
> the ath5k antenna control doesn't seem to be committed yet ?
>
> The original patch :  
> http://marc.info/?l=linux-wireless&m=123984229722724&w=4
> The revised version :  
> http://marc.info/?l=linux-wireless&m=124112144817141&w=4
>
> I've been trying to patch the sources myself, seems to have worked ok  
> and even compiled successfully but I'm lacking some knowledge on how to  
> now 'properly' test or deploy this newly compiled version of the ath5k  
> module to some wireless mesh nodes.
>
> I could probably get it working if I could just use compat-wireless and  
> follow the manual, but I don't think the patch has made it there yet.

You are looking in the wrong place?  The revised version is in both
wireless-testing and wireless-next-2.6.  It should be in 2.6.31 when
that is available.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
