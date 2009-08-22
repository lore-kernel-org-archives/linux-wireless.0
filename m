Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from serv.flidais.net ([64.142.75.214]:44637 "EHLO serv.flidais.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933244AbZHVS7U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 14:59:20 -0400
Received: from serv.flidais.net (localhost [127.0.0.1])
	by serv.flidais.net (Postfix) with ESMTP id 8415E20C3BC
	for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2009 12:02:20 -0700 (PDT)
Received: from [192.168.2.98] (unknown [64.142.75.212])
	by serv.flidais.net (Postfix) with ESMTPS id 616FA20C3BC
	for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2009 12:02:19 -0700 (PDT)
Message-ID: <4A904008.5090903@flidais.net>
Date: Sat, 22 Aug 2009 11:59:20 -0700
From: Nathan Kennedy <nathan@flidais.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Broadcom BCM43XG Master mode?
References: <4A903BEB.4030606@flidais.net> <1250967366.23605.23.camel@johannes.local>
In-Reply-To: <1250967366.23605.23.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2009-08-22 at 11:41 -0700, Nathan Kennedy wrote:
>   
>> I recently purchased a Linksys WMP300N that has teh BCM43XG chipset.  
>> The only driver that I've gotten to work well with it is the wl driver 
>> from Broadcom, however when I try to set the wireless mode to master I 
>> get an error that the operation is not permitted.  Is there a different 
>> way to get this card into master mode?
>>     
>
> If you're using wl, then we don't know, and you have to ask Broadcom.
>
> If you're using b43, you start hostapd.
>
> johannes
>   
Unfortunately the b43 driver will not load at all because there hasn't 
been an update to support this chipset.  Any devs want a guinea pig to 
test driver ideas?
