Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:32813 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbbFNPKe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jun 2015 11:10:34 -0400
Received: by obcej4 with SMTP id ej4so49556670obc.0
        for <linux-wireless@vger.kernel.org>; Sun, 14 Jun 2015 08:10:34 -0700 (PDT)
Message-ID: <557D9966.5050209@lwfinger.net> (sfid-20150614_171038_391606_CB56D88F)
Date: Sun, 14 Jun 2015 10:10:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arnaud LE CAM <arnaud.lecam@yahoo.fr>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Bug ?] 10ec:b723 Realtek RTL8723BE wireless card drops connection
References: <1434268591.3014.YahooMailBasic@web172003.mail.ir2.yahoo.com>
In-Reply-To: <1434268591.3014.YahooMailBasic@web172003.mail.ir2.yahoo.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/14/2015 02:56 AM, Arnaud LE CAM wrote:
> Larry and Jes,
>
> The problem is that wifi connection drops randomly (reconnecting each 600 sec.) when flwps option is set to 1.
> Many tests have been done on this bug, including with 4.1.0-040100rc7 kernel :
> - flwps=0 and ips=0 works fine ;
> - flwps=1 and ips=0 (equals to ips=0 with no other options) works fine only with 802.11g under 4.1.0-040100rc7 ;
> - flwps=0 and ips=1 works fine ;
> - flwps=1 and ips=1 results in a bug.
> This bug was triaged by Christopher M. Penalver on Ubuntu's Launchpad (https://bugs.launchpad.net/bugs/1459367) where all tests are attached.
>
> I hope it could help...

Never, ever, ever drop the Cc to the mailing list. By doing that, you are 
requesting private consultation, but without any offer to pay for such personal 
service. That is rude. In fact, I usually ignore such postings.

On the other hand, this description of the problem is nearly perfect. The reader 
does not have to look at pages of information that is likely not significant.

To address your problem, power saving does not work correctly on this device. 
That is why there are numerous posts on the web telling people to use ips=0. It 
seems that Ubuntu people never look at anything but the Ubuntu literature; 
however, I'm sure that I posted this "suggestion" there as well. The Realtek 
group is currently rewriting the entire dynamic management code for all their 
drivers. When complete, this should improve performance and should help the 
power-save condition. No, I do not know when the new code will be ready, or how 
much improvement it will make.

Larry


