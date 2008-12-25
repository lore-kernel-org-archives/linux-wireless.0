Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:19031 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYLYCUT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 21:20:19 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1085008yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Dec 2008 18:20:17 -0800 (PST)
Message-ID: <2d0a357f0812241820t43811845yaf833adc1d7d5e8d@mail.gmail.com> (sfid-20081225_032035_871929_419A6B99)
Date: Thu, 25 Dec 2008 03:20:17 +0100
From: "Sedat Dilek" <sedat.dilek@googlemail.com>
To: "Kalle Valo" <kalle.valo@iki.fi>
Subject: Re: [PATCH 10/10] iwl3945: use rx queue management infrastructure from iwlcore
Cc: "Zhu Yi" <yi.zhu@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Winkler, Tomas" <tomas.winkler@intel.com>
In-Reply-To: <87tz8ur5b5.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1229916683-9772-1-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-6-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-7-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-8-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-9-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-10-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-11-git-send-email-yi.zhu@intel.com>
	 <87r640s3ph.fsf@litku.valot.fi>
	 <1230001118.2570.35.camel@debian.sh.intel.com>
	 <87tz8ur5b5.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With wireless-testing master-2008-12-23 (also plus 2.6.28-rc9-git4
patch) everthing OK in iwl3945-world.
Both Linux kernel works fine.
Thank you for the gift.

-Sedat

# env COLUMNS=250 dpkg -l | grep linux-image | grep 2.6.28-rc9
ii  linux-image-2.6.28-rc9-git4-wl-gcc44
2.6.28~rc9+git4+wl~git20081223.fd1dae5~dileX+1           Linux kernel
binary image for version 2.6.28-rc9-git4-wl-gcc44
ii  linux-image-2.6.28-rc9-wl-gcc44
2.6.28~rc9+wl~git20081223.fd1dae5~dileX+1                Linux kernel
binary image for version 2.6.28-rc9-wl-gcc44

On Tue, Dec 23, 2008 at 9:43 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
> Zhu Yi <yi.zhu@intel.com> writes:
>
>> On Mon, 2008-12-22 at 22:07 +0800, Kalle Valo wrote:
>>> Yes, ifconfig up works but now iwlist wlan0 scan crashes. I just
>>> tested this once due to lack of time.
>>>
>>> I hope I get my wifi working before Christmas ;)
>>
>> http://marc.info/?l=linux-wireless&m=123000088608330&w=2 should fix the
>> problem. Thanks a lot for your testing.
>
> Yes, that patch fixed it. Now my wifi is working again, thank you for
> the present! :)
>
> Just to be clear, these are the patches I have applied on top of
> current wireless-testing:
>
> Revert "iwl3945: remove iwl-3945-led.[ch]"
> iwl3945: use rx queue management infrastructure from iwlcore
> iwlwifi: fix warning 'Should it be static'
> iwlwifi: kill retry_rate sysfs for iwlagn
> iwlwifi: move sysfs status entry to debugfs
> iwl3945: use iwl3945_tx_cmd instead of iwl_tx_cmd
> iwl3945: switch to the iwl-core send_card_state routine
> iwl3945: remove iwl-3945-led.[ch]
> iwl3945: sync tx queue data structure with iwlagn
> iwl3945: adding utils ops
> iwl3945: rearrange 3945 tfd
>
> If I spot any regressions, you will hear from me ;)
>
> --
> Kalle Valo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
