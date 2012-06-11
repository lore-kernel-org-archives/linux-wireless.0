Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:40941 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab2FKEDB convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Mon, 11 Jun 2012 00:03:01 -0400
Received: by bkcji2 with SMTP id ji2so3148861bkc.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jun 2012 21:02:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338894402.4514.28.camel@jlt3.sipsolutions.net>
References: <CALx5=V8gS-FudA0EAmoEs=xwQ7hr_BntO4Jr_+6tR9pYSNDUdg@mail.gmail.com>
	<1338894402.4514.28.camel@jlt3.sipsolutions.net>
Date: Mon, 11 Jun 2012 12:02:47 +0800
Message-ID: <CALx5=V9GPe0ad2=im4bvS0AMdXVQ7TF-dkW_dgUG1H1S1ek=3A@mail.gmail.com> (sfid-20120611_060305_312609_51B79A07)
Subject: Re: Connected standby support ?
From: Matt Chen <machen@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, users@rt2x00.serialmonkey.com,
	joeyli <jlee@suse.com>, Michael Chang <mchang@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

What is wowlan ? Does it need BIOS suuport ?

2012/6/5 Johannes Berg <johannes@sipsolutions.net>:
> On Tue, 2012-06-05 at 10:53 +0800, Matt Chen wrote:
>> Hi list,
>> As the incoming UEFI new design for BIOS, Microsoft has already
>> provided a model, "connected standby",  for power management. There
>> are 3 modes which are S0, Low Power S0 and S5.
>> I am wondering if there is already any support for the connected
>> standby in wifi of Linux ?
>
> That's what we call wowlan, right? Or can be implemented using it?
>
> johannes
>
>



-- 
Thank you.
