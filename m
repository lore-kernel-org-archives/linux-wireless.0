Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:53583 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbYH1O3b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 10:29:31 -0400
Received: by nf-out-0910.google.com with SMTP id d3so67811nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2008 07:29:30 -0700 (PDT)
Message-ID: <1ba2fa240808280729vc3f39detce9f28863075ef6c@mail.gmail.com> (sfid-20080828_162934_262461_6C4C7487)
Date: Thu, 28 Aug 2008 17:29:30 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: [PATCH 07/11] iwlwifi: generic init calibrations framework
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1219932759.6064.69.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-8-git-send-email-yi.zhu@intel.com>
	 <1219926977.6064.21.camel@californication>
	 <1ba2fa240808280420i21b7390bufeec5d8819e2723@mail.gmail.com>
	 <1219932759.6064.69.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2008 at 5:12 PM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Tomas,
>
>> >> This patch fixes a critical bug that only the last calibration result
>> >> was applied. On reception of one calibration result all the calibration
>> >> was freed. The patch fixes this problem by introducing a generic init
>> >> calibration framework which allows variable number of init calibrations
>> >> and allows addition new HW.
>> >
>> > a lot of code changes in -rc4 phase. Please give more details since the
>> > patch changes a lot and even introduces a new EXPORT.
>>
>> The first sentence is important, the whole framework was buggy.
>
> I got that part, but understand that just changing a framework at the
> state of -rc4 is never a good idea. Any possible regression that might
> come out of it, could delay the release.
>
> In this case it would actually help to have clear Reviewed-by or
> Tested-by statements in the patch. Signed-off only states the authors
> and doesn't give this change more credit.

Oh, man that fix went through Intel Validation (TM), With $500K scope
attached, checking RXIQ, TXIQ, LO, Power and got certification from
independent lab. Enough is enough.
Tomas
