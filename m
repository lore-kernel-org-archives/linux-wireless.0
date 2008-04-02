Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.189]:11839 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbYDBUNe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 16:13:34 -0400
Received: by rn-out-0910.google.com with SMTP id e24so1806366rng.1
        for <linux-wireless@vger.kernel.org>; Wed, 02 Apr 2008 13:13:33 -0700 (PDT)
Message-ID: <1ba2fa240804021313l59b34b7cy5fba78d62d9fac58@mail.gmail.com> (sfid-20080402_211344_193638_67322686)
Date: Wed, 2 Apr 2008 23:13:33 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Miles Lane" <miles.lane@gmail.com>
Subject: =?WINDOWS-1252?Q?Re:_2.6.25-rc8-mm1_--_drivers/ne?= =?WINDOWS-1252?Q?t/wireless/iwlwifi/iwl-led.c:184?= =?WINDOWS-1252?Q?:_error:_=91struct_iwl=5Fpriv=92_has_n?= =?WINDOWS-1252?Q?o_member_named_=91last=5Fblink=5Ftime=92?=
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, "Zhu Yi" <yi.zhu@intel.com>,
	wireless <linux-wireless@vger.kernel.org>,
	reinette.chatre@intel.com
In-Reply-To: <a44ae5cd0804020404k295ffc7ew8761cc0901996e20@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <a44ae5cd0804020404k295ffc7ew8761cc0901996e20@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 2, 2008 at 2:04 PM, Miles Lane <miles.lane@gmail.com> wrote:




>  CONFIG_IWLCORE=m
>  CONFIG_IWLWIFI_LEDS=y
>  # CONFIG_IWL4965 is not set
>  CONFIG_IWL3945=m
>  # CONFIG_IWL3945_SPECTRUM_MEASUREMENT is not set
>  # CONFIG_IWL3945_LEDS is not set
>  # CONFIG_IWL3945_DEBUG is not set

This is a known problem please do use CONFIG_IWLWIFI_LEDS=y when not
compiling IWL4965
The fix need some more coding, we will fix this soon.
Thanks
Tomas
