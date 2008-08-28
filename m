Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:27741 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbYH1PeA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 11:34:00 -0400
Received: by ug-out-1314.google.com with SMTP id c2so1175753ugf.37
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2008 08:33:58 -0700 (PDT)
Message-ID: <f6ca9fed0808280833w5205ad88gf588ec7fa36c48a@mail.gmail.com> (sfid-20080828_173406_377344_C366F34B)
Date: Thu, 28 Aug 2008 17:33:58 +0200
From: drago01 <drago01@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: [PATCH 06/11] iwlwifi: fix apm_stop
Cc: "Tomas Winkler" <tomasw@gmail.com>, "Zhu Yi" <yi.zhu@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Mohamed Abbas" <mohamed.abbas@intel.com>
In-Reply-To: <1219934050.6064.89.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
	 <1219926807.6064.17.camel@californication>
	 <1ba2fa240808280421g642ddc62j7541837f874f79df@mail.gmail.com>
	 <1219934050.6064.89.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2008 at 4:34 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Tomas,
>
>> >> The patch fixes CSR_GP_CNTRL_REG_FLAG_INIT_DONE was set instead of
>> >> cleared which disabled moving device to D0U state.
>> >
>> > when was this mistake introduced. Is it a regression compared to what we
>> > have in 2.6.26?
>>
>> Again. think of global warming.
>
> I fully get why we wanna fix that. That was not my questions. Is this a
> regression compared to what we have in 2.6.26? Yes or no. A clear yes
> make this a regression and we will not even discuss this any further.
> That patch should go in then. In the no case you have to come up with
> some good argument.

there is also the big vs large impact argument if the fix (note "fix"
not feature) is unlikely to break stuff there is no reason for it to
not go in.
