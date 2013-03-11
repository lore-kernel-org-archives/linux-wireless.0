Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lerya.net ([213.251.186.118]:37863 "EHLO mx.lerya.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab3CKSia (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 14:38:30 -0400
Date: Mon, 11 Mar 2013 19:38:25 +0100
From: Vincent Brillault <gentoo@lerya.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Warnings with ASUS PCE-N15 (RTL8188CE)
Message-ID: <20130311183825.GG3009@Fea.lerya.net> (sfid-20130311_193835_312913_02739215)
References: <20130307192920.GB8668@Fea.lerya.net>
 <20130308215833.GA2829@Fea.lerya.net>
 <513A960B.2020304@lwfinger.net>
 <20130309113222.GA3009@Fea.lerya.net>
 <513B7E58.9000505@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <513B7E58.9000505@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for the delay.

On Sat  9.Mar'13 at 12:24:24 -0600, Larry Finger wrote:
> On 03/09/2013 05:32 AM, Vincent Brillault wrote:
> You can safely ignore them, but I wonder why I have not seen them. What is the 
> configuration of your AP? Is it g or n?
It's a b/g AP.

> I have been doing tests on rtl8723ae for the past week, and I do not get those 
> disconnects. Obviously, I need to find what differs between the two drivers in 
> that respect. I suspect something in the rekeying part of TKIP.
I confirm that I'm using TKIP on that network.

If I can help you in any way, please tell me,
Vincent
