Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51194 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab1HaUsZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 16:48:25 -0400
Received: by gxk21 with SMTP id 21so903652gxk.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 13:48:25 -0700 (PDT)
Message-ID: <4E5E9E16.3030306@lwfinger.net> (sfid-20110831_224829_825885_C88F07AA)
Date: Wed, 31 Aug 2011 15:48:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Matthew Frazier <mlfrazie@ncsu.edu>
CC: linux-wireless@vger.kernel.org
Subject: Re: Status of BCM4331
References: <D23A4EC8-E27C-476C-BA73-64EAB4E81B62@ncsu.edu>
In-Reply-To: <D23A4EC8-E27C-476C-BA73-64EAB4E81B62@ncsu.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/31/2011 03:27 PM, Matthew Frazier wrote:
> Hello, Linux wireless people.
>
> On the b43 device list[1], you have support for the BCM4331 listed as "Soon (3.2+)". Does this mean "it will be in 3.2," "we will start working on it after 3.2," or something else?

Support for that chip will be in kernel 3.2. In fact, the code now in the 
wireless testing git tree handles that chip without any other changes (as of the 
August 30 update).

> Also, just out of curiosity, what are you working on specifically with regards to the BCM4331? What still needs to be done before the BCM4331 can be used? (And does Broadcom have any plans to support it with the broadcom-sta driver?)

The object has been to make it work at all. It uses a new interface between the 
chip and the host, and is different than any device previously supported by b43. 
There will be additional improvements to improve the performance, and perhaps 
the stability.

None of us are qualified to speak regarding Broadcom's plans.

Larry


