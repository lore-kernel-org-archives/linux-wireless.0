Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:24634 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487AbYALJUb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2008 04:20:31 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1448108fga.17
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jan 2008 01:20:28 -0800 (PST)
Message-ID: <478884ED.6030105@gmail.com> (sfid-20080112_092035_979022_7650073F)
Date: Sat, 12 Jan 2008 10:14:21 +0100
From: Ronald <ronald645@gmail.com>
Reply-To: ronald645@gmail.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Bcm4311 shuts down on closing lid (intended?)
References: <47866FE6.4010100@gmail.com>	 (sfid-20080110_192630_077617_B3331316) <1200052973.3861.167.camel@johannes.berg>	 <47876C32.8090004@gmail.com>	 (sfid-20080111_132311_007072_430845CE) <1200062822.3861.169.camel@johannes.berg>	 <478786FD.1020603@gmail.com> (sfid-20080111_151707_941155_90686314) <1200088039.3528.1.camel@johannes.berg>
In-Reply-To: <1200088039.3528.1.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> I'm not quite sure anymore about the bcm43xx behaviour. But I'm sure of 
>> ndiswrapper. Need to test bcm43xx?
> 
> Ok, well, I'd expect it to be the signal strength then. The original
> driver may well be doing better than b43 for obvious reasons.
> 
> johannes
Good point, the old driver is more stable. But both ndiswrapper and 
bcm43xx fail to initiate WPA2 connections.

							Ronald
