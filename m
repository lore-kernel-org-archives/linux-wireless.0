Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:43489 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbZHNR0H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 13:26:07 -0400
Received: by bwz22 with SMTP id 22so1266379bwz.18
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 10:26:07 -0700 (PDT)
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linville\@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel\@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Guy\, Wey-Yi W" <wey-yi.w.guy@intel.com>
Subject: Re: [PATCH 16/16] iwlwifi: disable powersave mode
References: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
	<1249684912-22936-17-git-send-email-reinette.chatre@intel.com>
	<878whun256.fsf@litku.valot.fi> <1249760168.30019.5588.camel@rc-desk>
	<87k518kgmm.fsf@litku.valot.fi> <1250114006.30019.6030.camel@rc-desk>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 14 Aug 2009 20:20:53 +0300
In-Reply-To: <1250114006.30019.6030.camel@rc-desk> (reinette chatre's message of "Wed\, 12 Aug 2009 14\:53\:26 -0700")
Message-ID: <871vne1fd6.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reinette chatre <reinette.chatre@intel.com> writes:

>> What I'm worried is the complexity of the driver interfaces and
>> configuration methods. For iwlwifi power save, after this patch, we have
>> now:
>> 
>> o Wireless Extensions
>> o sysfs
>> o CONFIG_CFG80211_DEFAULT_PS Kconfig parameter
>
> We could not see how any of the current measures can be used to
> accomplish out goal. Fortunately Johannes implemented something that now
> can be used to accomplish this.

Yes, Johannes' idea is a perfect compromise. Thank you both.

-- 
Kalle Valo
