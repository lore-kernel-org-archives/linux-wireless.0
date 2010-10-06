Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:54084 "HELO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757417Ab0JFOJP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 10:09:15 -0400
Received: by mail-ww0-f53.google.com with SMTP id 33so2478729wwc.22
        for <linux-wireless@vger.kernel.org>; Wed, 06 Oct 2010 07:09:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101006135221.GE2472@tuxdriver.com>
References: <1285965206-17777-1-git-send-email-gadiyar@ti.com>
 <20101001231026.GH3117@atomide.com> <1286279588.15401.28.camel@chilepepper>
 <1286280426.15401.29.camel@chilepepper> <1286284790.15401.53.camel@chilepepper>
 <1286311187.2793.7.camel@powerslave> <20101006135221.GE2472@tuxdriver.com>
From: "Gadiyar, Anand" <gadiyar@ti.com>
Date: Wed, 6 Oct 2010 19:31:39 +0530
Message-ID: <AANLkTinHA+JS1MObanawFF8ktW6OEMGr7CnJhakUetPz@mail.gmail.com>
Subject: Re: [PATCH] omap: zoom2/3: fix build caused by wl1271 support
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	ext Tony Lindgren <tony@atomide.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Hmmm... We got a problem here.  This patch breaks builds when we *don't*
>> have "omap: mmc extended to pass host capabilities from board file".  We
>> don't have that on wireless-next yet, so builds with zoom boards
>> selected are broken.
>>
>> Any ideas on how to solve this dilemma? I guess the proper way to handle
>> this would be to make the changes proposed in this patch when merging
>> instead of having a normal commit for it, wouldn't it?
>
> Just cherry-pick that change into the branch of your tree that I do
> _not_ pull from.  I presume that it is already available in linux-next?
>

Yup - both patches are in linux-next; that's where we noticed the build break.

- Anand
