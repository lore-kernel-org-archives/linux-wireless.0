Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:47467 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbYH1LV3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 07:21:29 -0400
Received: by ey-out-2122.google.com with SMTP id 6so98008eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2008 04:21:28 -0700 (PDT)
Message-ID: <1ba2fa240808280421g642ddc62j7541837f874f79df@mail.gmail.com> (sfid-20080828_132132_415958_8B7C22C7)
Date: Thu, 28 Aug 2008 14:21:27 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: [PATCH 06/11] iwlwifi: fix apm_stop
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Mohamed Abbas" <mohamed.abbas@intel.com>
In-Reply-To: <1219926807.6064.17.camel@californication>
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2008 at 3:33 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Yi,
>
>> The patch fixes CSR_GP_CNTRL_REG_FLAG_INIT_DONE was set instead of
>> cleared which disabled moving device to D0U state.
>
> when was this mistake introduced. Is it a regression compared to what we
> have in 2.6.26?

Again. think of global warming.
Tomas
