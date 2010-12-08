Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm6.bullet.mail.ne1.yahoo.com ([98.138.90.69]:40656 "HELO
	nm6.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751432Ab0LHVd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 16:33:27 -0500
Message-ID: <401121.57601.qm@web120213.mail.ne1.yahoo.com>
References: <368544.4876.qm@web120203.mail.ne1.yahoo.com> <201012082052.51358.chunkeey@googlemail.com> <326185.97637.qm@web120219.mail.ne1.yahoo.com> <201012082159.09406.chunkeey@googlemail.com>
Date: Wed, 8 Dec 2010 13:33:25 -0800 (PST)
From: Chris Pechard <chrispechard@yahoo.com>
Subject: Re: carl9170fw: custom build incompatibility issue
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201012082159.09406.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Christian for the quick turnaround, option 2 did it.

Chris.


----- Original Message ----
From: Christian Lamparter <chunkeey@googlemail.com>
To: Chris Pechard <chrispechard@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Sent: Wed, December 8, 2010 12:59:09 PM
Subject: Re: carl9170fw: custom build incompatibility issue

On Wednesday 08 December 2010 21:33:43 Chris Pechard wrote:
> Hi Christian,
> 
> this is the info you requested. 

The only thing wrong is the lack of fw metadata (which is kind of
obvious since the the firmware is somewhat customizable).


You have two options:

- either concat carl9170.fw and carl9170.dsc into carl9170-1.fw
   (by hand).

- autogen.sh install [also adds miniboot + fw checksum]
   (since CONFIG_CARL9170FW_MAKE_RELEASE is y,
    and CONFIG_CARL9170FW_RELEASE_VERSION=1)

Best Regards,
    Christian 



      
