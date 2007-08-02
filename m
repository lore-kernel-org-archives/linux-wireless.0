Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:33937 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411AbXHBJSG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 05:18:06 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id 33C341804B256
	for <linux-wireless@vger.kernel.org>; Thu,  2 Aug 2007 10:18:05 +0100 (BST)
Received: from meerkat.home.warmcat.com (localhost [127.0.0.1])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id D35531B3D6
	for <linux-wireless@vger.kernel.org>; Thu,  2 Aug 2007 09:18:12 +0000 (UTC)
Message-ID: <46B1A14B.2070808@warmcat.com>
Date: Thu, 02 Aug 2007 10:18:03 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: chaning mode only when interface down?
References: <46B18B77.5020802@gmail.com> <1186046044.24230.11.camel@johannes.berg>
In-Reply-To: <1186046044.24230.11.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

>> Because of this NM can't create ad-hoc networks because it does it while 
>> the device is up.
>> Any ideas?
> 
> Fix NM?

It can easily try it one way and if it fails, try the other.

NM has some other things that needed fixing last time I looked at it...
it thought it knew better than I did if a wireless interface was in
Monitor mode that I "really wanted it" to be in Managed.

-Andy
