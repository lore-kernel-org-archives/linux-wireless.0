Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab1AaP03 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 10:26:29 -0500
Date: Mon, 31 Jan 2011 16:26:12 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 7/8] iwlagn: remove
 CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
Message-ID: <20110131152611.GA5562@redhat.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
 <1296229671-3041-7-git-send-email-sgruszka@redhat.com>
 <1296231817.7388.18.camel@wwguy-ubuntu>
 <20110128164136.GF2452@redhat.com>
 <1296256821.8832.1.camel@wwguy-ubuntu>
 <20110131094624.GA20641@redhat.com>
 <AANLkTinBneG0nqGFt=mnP0-ZSdLGzdxhfYpyo62WYJQA@mail.gmail.com>
 <20110131112916.GA22367@redhat.com>
 <1296486101.10026.7.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1296486101.10026.7.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 31, 2011 at 07:01:41AM -0800, wwguy wrote:
> > With module option:
> > 
> > sgruszka: download exp firmware and load module with use_experimental_fw=1
> > user: ok, but how to do this 
> > sgruszka: echo "options iwlagn use_experiental_fw=1" >> /etc/modprobe.d/iwlwifi.conf
> > sgruszka: and restart the system
> > user: hmm, I have error
> > user: bash: /etc/modprobe.d/iwlwifi.conf: Permission denied 
> > sgruszka: login as root
> > user: ok I did, but new firmware did not help me
> > sgruszka: show me dmesg please
> > user: dmesg
> > sgruszka: old firmware is used
> > sgruszka: gash, I made a typo, it should be
> > sgruszka: echo "options iwlagn use_experimental_fw=1" >> /etc/modprobe.d/iwlwifi.conf
> > sgruszka: grrrrrrr
> > 
> there is a "ucode_alternative" module parameter already there which
> doing the similar thing
> 
> I agree there will be mistake, but whoever want to use the experimental
> uCode should know what they are doing, otherwise, regular uCode
> works.right?

If you mean that only experienced linux users should be able to use
experimental firmware, I do not share that opinion. I dislike making
things not necessary complex and supporting driver harder, but I'll
not argue about that.

Stanislaw
