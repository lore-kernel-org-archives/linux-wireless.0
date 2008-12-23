Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:28787 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYLWUnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 15:43:16 -0500
Received: by fg-out-1718.google.com with SMTP id 19so1023020fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 12:43:14 -0800 (PST)
To: Zhu Yi <yi.zhu@intel.com>
Cc: "linville\@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel\@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Winkler\, Tomas" <tomas.winkler@intel.com>
Subject: Re: [PATCH 10/10] iwl3945: use rx queue management infrastructure from iwlcore
References: <1229916683-9772-1-git-send-email-yi.zhu@intel.com>
	<1229916683-9772-2-git-send-email-yi.zhu@intel.com>
	<1229916683-9772-3-git-send-email-yi.zhu@intel.com>
	<1229916683-9772-4-git-send-email-yi.zhu@intel.com>
	<1229916683-9772-5-git-send-email-yi.zhu@intel.com>
	<1229916683-9772-6-git-send-email-yi.zhu@intel.com>
	<1229916683-9772-7-git-send-email-yi.zhu@intel.com>
	<1229916683-9772-8-git-send-email-yi.zhu@intel.com>
	<1229916683-9772-9-git-send-email-yi.zhu@intel.com>
	<1229916683-9772-10-git-send-email-yi.zhu@intel.com>
	<1229916683-9772-11-git-send-email-yi.zhu@intel.com>
	<87r640s3ph.fsf@litku.valot.fi>
	<1230001118.2570.35.camel@debian.sh.intel.com>
Date: Tue, 23 Dec 2008 22:43:10 +0200
In-Reply-To: <1230001118.2570.35.camel@debian.sh.intel.com> (Zhu Yi's message of "Tue\, 23 Dec 2008 10\:58\:37 +0800")
Message-ID: <87tz8ur5b5.fsf@litku.valot.fi> (sfid-20081223_214323_592120_83F3FCB6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Kalle Valo <kalle.valo@iki.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zhu Yi <yi.zhu@intel.com> writes:

> On Mon, 2008-12-22 at 22:07 +0800, Kalle Valo wrote:
>> Yes, ifconfig up works but now iwlist wlan0 scan crashes. I just
>> tested this once due to lack of time.
>> 
>> I hope I get my wifi working before Christmas ;)
>
> http://marc.info/?l=linux-wireless&m=123000088608330&w=2 should fix the
> problem. Thanks a lot for your testing.

Yes, that patch fixed it. Now my wifi is working again, thank you for
the present! :)

Just to be clear, these are the patches I have applied on top of
current wireless-testing:

Revert "iwl3945: remove iwl-3945-led.[ch]"
iwl3945: use rx queue management infrastructure from iwlcore
iwlwifi: fix warning 'Should it be static'
iwlwifi: kill retry_rate sysfs for iwlagn
iwlwifi: move sysfs status entry to debugfs
iwl3945: use iwl3945_tx_cmd instead of iwl_tx_cmd
iwl3945: switch to the iwl-core send_card_state routine
iwl3945: remove iwl-3945-led.[ch]
iwl3945: sync tx queue data structure with iwlagn
iwl3945: adding utils ops
iwl3945: rearrange 3945 tfd

If I spot any regressions, you will hear from me ;)

-- 
Kalle Valo
