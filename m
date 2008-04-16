Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:32980 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751750AbYDPOaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 10:30:14 -0400
Message-ID: <48060D71.6020507@lwfinger.net> (sfid-20080416_153030_511650_053CA99D)
Date: Wed, 16 Apr 2008 09:30:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: Jiri Benc <jbenc@suse.cz>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: 2.6.25-rc9 -- bcm4306 performance is in the toilet
References: <48056406.2060502@gmail.com>
In-Reply-To: <48056406.2060502@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Miles Lane wrote:
> Hi,
> 
> I have a bcm4306 card in my desktop machine.  I am running a build of 
> 2.6.25-rc9.  I have tried fiddling with the network build options and no 
> matter what I select, my network performance is absolutely terrible 
> (between 0 - 24KBps).  Connections take around 10-20 seconds to 
> establish.  I have a cable modem, and usually see nearly instantaneous 
> connections and between 65-600KBps throughput.  I just tried downloading 
> something and am seeing this:  223B/s.  Everything is intermittent and 
> and often times out.
> 
> I am attempting to collect a log for you to analyze.  However, I am 
> running into some snags.
> 1)  The latest firmware, which is called for in the latest kernel code, 
> won't work with my Ubuntu 8.10 kernel (2.6.24-16-386).  I got the latest 
> iw git code downloaded, but it won't build for me:

Which revision of the BCM4306 do you have? Which driver (b43, 
b43legacy, or bcm43xx) are you running?

Based on comment 1) above, I think you are using b43, but why should I 
have to guess?

Larry

