Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41984 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758775Ab2CMAy5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 20:54:57 -0400
Received: by yenl12 with SMTP id l12so3255166yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Mar 2012 17:54:56 -0700 (PDT)
Message-ID: <4F5E9ADD.8050307@lwfinger.net> (sfid-20120313_015502_378831_D976D384)
Date: Mon, 12 Mar 2012 19:54:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: alupu@verizon.net
CC: linux-wireless@vger.kernel.org
Subject: Re: r8712u staging in kernel 3.2.9
References: <6340383.366730.1331593362221.JavaMail.root@vznit170128>
In-Reply-To: <6340383.366730.1331593362221.JavaMail.root@vznit170128>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/12/2012 06:02 PM, alupu@verizon.net wrote:

I tried again with the i686 Live CD.

You need to use YOUR essid and WEP key. Once you enter the 'iwconfig wlan0 essid 
xxxxxx', that triggers the association step, and it will never be able to see MY 
AP from your location. After association, then entering the WEP key will start 
the authentication. Similarly, I think it will not report back the essid unless 
that AP has been seen in a scan, but that is hard to test. Please try again 
using your values.

Larry

