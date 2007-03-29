Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:37130 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334AbXC2LRk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 07:17:40 -0400
Message-ID: <460BA04A.7090403@warmcat.com>
Date: Thu, 29 Mar 2007 12:17:30 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/4] mac80211: Coding style cleanups
References: <20070320103955.600509703@warmcat.com>	 <20070320104104.112865979@warmcat.com> <1174503503.3944.50.camel@johannes.berg>
In-Reply-To: <1174503503.3944.50.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2007-03-20 at 10:39 +0000, andy@warmcat.com wrote:
> 
> I don't really see why this is necessary at all, but anyway.

Yeah I cam to the same view -- I changed the file to match your 
suggestions here and realized that the (many) existing function defs do 
not follow your style recommendation.  So I mass-changed them and it 
came to me I will only annoy the original author by this attempt at 
consistency.  I started breaking out code into other functions and I 
realized I wasn't taking enough care, because it wasn't what I was 
trying to achieve, and would have to test it, might introduce bugs and 
would be run out of town by a mob with pitchforks.

I deleted the patch and learned to stop getting a tic in my eye every 
time a line > 80 cols flys by.

-Andy
