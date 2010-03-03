Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coco.cs.washington.edu ([128.208.3.82]:53659 "EHLO
	coco.cs.washington.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab0CCWyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 17:54:45 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Apple Message framework v1077)
Subject: Re: [ipw3945-devel] iwl4965: 11a channels disabled in current wireless-testing
From: Daniel Halperin <dhalperi@cs.washington.edu>
In-Reply-To: <1267651173.15761.155.camel@rchatre-DESK>
Date: Wed, 3 Mar 2010 14:54:37 -0800
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Message-Id: <0A6DB552-23FC-46ED-9326-60EB0370C062@cs.washington.edu>
References: <201002281534.11656.helmut.schaa@googlemail.com> <201003011927.53208.helmut.schaa@googlemail.com> <43e72e891003011059v564931e2qfe390657b698c277@mail.gmail.com> <201003022047.10196.helmut.schaa@googlemail.com> <1267640304.15761.121.camel@rchatre-DESK> <03690D90-3C5E-4E37-8BC6-7EE6FE0B4E1D@cs.washington.edu> <1267651173.15761.155.camel@rchatre-DESK>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mar 3, 2010, at 1:19 PM, reinette chatre wrote:
> 
>> With some update between now and a while ago (October?) I can no
>> longer even monitor on most 11a channels. (E.g., "iwconfig wlan0 mode
>> monitor ; iwconfig wlan0 channel 64" returns an error). This was not
>> the old behavior, and seems to be wrong to me.
> 
> What error do you get? Have you tried to set up monitor channel using
> iw? Is bisect an option to try to find out what caused this?

Haven't dug into it yet; I will though!

Dan
