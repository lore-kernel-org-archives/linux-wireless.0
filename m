Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:48976 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbYH1LUl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 07:20:41 -0400
Received: by ey-out-2122.google.com with SMTP id 6so97908eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2008 04:20:40 -0700 (PDT)
Message-ID: <1ba2fa240808280420i21b7390bufeec5d8819e2723@mail.gmail.com> (sfid-20080828_132044_778419_DE994BDF)
Date: Thu, 28 Aug 2008 14:20:39 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: [PATCH 07/11] iwlwifi: generic init calibrations framework
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1219926977.6064.21.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-8-git-send-email-yi.zhu@intel.com>
	 <1219926977.6064.21.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2008 at 3:36 PM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Yi,
>
>> This patch fixes a critical bug that only the last calibration result
>> was applied. On reception of one calibration result all the calibration
>> was freed. The patch fixes this problem by introducing a generic init
>> calibration framework which allows variable number of init calibrations
>> and allows addition new HW.
>
> a lot of code changes in -rc4 phase. Please give more details since the
> patch changes a lot and even introduces a new EXPORT.

The first sentence is important, the whole framework was buggy.
Tomas
