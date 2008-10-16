Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:55382 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbYJPGeT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2008 02:34:19 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3018689wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 15 Oct 2008 23:34:08 -0700 (PDT)
Message-ID: <a8e1da0810152334x6c596f88i1fd74548dc166f3a@mail.gmail.com> (sfid-20081016_083423_363448_935ED479)
Date: Thu, 16 Oct 2008 14:34:07 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [BUG] hang with ath5k
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <48F6133D.1070508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <a8e1da0810140142g633486br12c2799b2fa1670e@mail.gmail.com>
	 <48F6133D.1070508@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 15, 2008 at 11:58 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 10/14/2008 10:42 AM, Dave Young wrote:
>> 1) run wpa_supplicant
>> 2) ctrl + C
>> 3) goto 1)
>
> It doesn't happen here. How many iterations in average you need to reproduce this?
>

About 15 times for me,
BTW, wpa_gui running while testing

-- 
Regards
dave
