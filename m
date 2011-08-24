Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35380 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab1HXVMu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 17:12:50 -0400
Received: by pzk37 with SMTP id 37so1316335pzk.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 14:12:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110824183128.GJ9770@tuxdriver.com>
References: <1313489647-8979-1-git-send-email-zajec5@gmail.com>
	<20110824183128.GJ9770@tuxdriver.com>
Date: Wed, 24 Aug 2011 23:12:49 +0200
Message-ID: <CACna6rwiB+8NR=VHY_4n_85Khj-vxxH=crU3mUWnSEHU_yZMUQ@mail.gmail.com> (sfid-20110824_231253_371487_EE934CCC)
Subject: Re: [RFC][PATCH V2] b43: drop Kconfig option of forcing PIO mode
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Larry Finger <larry.finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 24 sierpnia 2011 20:31 użytkownik John W. Linville
<linville@tuxdriver.com> napisał:
> On Tue, Aug 16, 2011 at 12:14:07PM +0200, Rafał Miłecki wrote:
>> We have module param called use_pio which is much easier to use.
>>
>> Cc: Larry Finger <larry.finger@lwfinger.net>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> V2: include b43.h change
>>
>> Larry introduced use_pio with:
>>     b43: Allow PIO mode to be selected at module load
>> I believe we can leave this simple module param and drop
>> CONFIG_B43_FORCE_PIO instead.
>
> Seems reasonable to me...any objections?

Thank you for taking care of this John. I hope to get patches straight
in the future (now, when I understand the way you treat RFC/RFT).

-- 
Rafał
