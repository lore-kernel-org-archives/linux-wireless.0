Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.241]:50867 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069AbYGQKHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 06:07:50 -0400
Received: by hs-out-0708.google.com with SMTP id 4so1631854hsl.5
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2008 03:07:49 -0700 (PDT)
Message-ID: <43e72e890807170307g3310ffcbv51f89c93dfbc64a0@mail.gmail.com> (sfid-20080717_120753_874631_1EBEA86E)
Date: Thu, 17 Jul 2008 03:07:48 -0700
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Yingying Zhao" <yingying.zhao@linux.intel.com>
Subject: Re: [PATCH]compat-2.6: fix compiling configurations for iwlwifi
Cc: "Tomas Winkler" <tomasw@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20080717100449.GB1279@amber-desktop.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080717081554.GA1279@amber-desktop.bj.intel.com>
	 <1ba2fa240807170129w251a95f3i8eab918d50a77f97@mail.gmail.com>
	 <43e72e890807170248v7a873c15oc3aea315a59e9f19@mail.gmail.com>
	 <20080717100449.GB1279@amber-desktop.bj.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 17, 2008 at 3:04 AM, Yingying Zhao
<yingying.zhao@linux.intel.com> wrote:

>> Also, was this tested with 2.6.22?
>>
>>   Luis
> No. I just tested on 2.6.24.
> I'll wait for iwlwifi Kconfig is finalized by Tomas and retest this on
> 2.6.22.

OK cool -- just a heads up then, I hadn't enabled LEDs or RFKILL
options for drivers as the framework needs backporting. Once
backported I expect it will compile well for older kernels.

  Luis
