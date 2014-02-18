Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:42817 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaBRWKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 17:10:54 -0500
Received: by mail-pb0-f52.google.com with SMTP id jt11so17400312pbb.11
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 14:10:54 -0800 (PST)
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <20140218203646.GQ26776@mwanda>
References: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com>
 <1392685846-10116-4-git-send-email-andrea.merello@gmail.com>
 <20140218093135.GJ26776@mwanda> <CAN8YU5N=_-9hVZc+6sW5xrwmybQ_aTLAMFODzyuGk0g97OV6Gg@mail.gmail.com>
 <20140218182714.GO26776@mwanda> <CAN8YU5P1-7TxvDFifEWPhGh3MbLP_DMJWS9Sbzte+TDcuELKLg@mail.gmail.com>
 <20140218192239.GP26776@mwanda> <CAN8YU5PQSNZHmEG6o2-uRQMo1G14M7ot-_KiHT2u=-4LCaremA@mail.gmail.com>
 <20140218203646.GQ26776@mwanda>
From: Andrea Merello <andrea.merello@gmail.com>
Date: Tue, 18 Feb 2014 23:10:33 +0100
Message-ID: <CAN8YU5OK8MLc0y0NaMJSJLOnh1K2FjLmEQiJ4fGd=Nyi5neUeQ@mail.gmail.com> (sfid-20140218_231057_956438_9E030BCA)
Subject: Re: [PATCH 3/7] rtl818x: check for pci_map_single() success when
 initializing RX ring
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: John Linville <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	Huqiu Liu <liuhq11@mails.tsinghua.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No, I didn't know about that.. I will give a look to git documentation..
Thank you for telling me about it :)

Andrea


On Tue, Feb 18, 2014 at 9:36 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Tue, Feb 18, 2014 at 09:17:22PM +0100, Andrea Merello wrote:
>> Ok, I will fix my patch in this way.
>> I will resend it.
>> Should I also rebase following patches in the patch serie and resent them also?
>>
>
> Don't rebase if you don't have to.
>
> Do you know how to use the In-Reply-To header so that the v2 patch will
> show up in the thread?  There is an --in-reply-to option in git
> send-email.
>
> regards,
> dan carpenter
>
