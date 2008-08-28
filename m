Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:52140 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbYH1Lly (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 07:41:54 -0400
Received: by ey-out-2122.google.com with SMTP id 6so100074eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2008 04:41:52 -0700 (PDT)
Message-ID: <1ba2fa240808280441v2a1f1014t52c4bacf69f901af@mail.gmail.com> (sfid-20080828_134156_865075_EB0380E2)
Date: Thu, 28 Aug 2008 14:41:52 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 06/11] iwlwifi: fix apm_stop
Cc: "Marcel Holtmann" <marcel@holtmann.org>,
	"Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Mohamed Abbas" <mohamed.abbas@intel.com>
In-Reply-To: <200808281338.46894.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
	 <1219926807.6064.17.camel@californication>
	 <200808281338.46894.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2008 at 2:38 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Thursday 28 August 2008, Marcel Holtmann wrote:
>> Hi Yi,
>>
>> > The patch fixes CSR_GP_CNTRL_REG_FLAG_INIT_DONE was set instead of
>> > cleared which disabled moving device to D0U state.
>>
>> when was this mistake introduced. Is it a regression compared to what we
>> have in 2.6.26?
>
> I think you are overstretching the regression-fixes-only rule a little bit...
> It will help nobody, if we don't fix actual _bugs_ and push such fixes
> into the next merge window.
>
> Our goal is to have a stable kernel on release. We don't get to that goal, if
> we defer bugfixes to the next merge window.

Oh, good I have friends after all :)
Tomas
