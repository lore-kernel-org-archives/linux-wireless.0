Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:35298 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbYEEJbT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 05:31:19 -0400
Received: by rv-out-0506.google.com with SMTP id l9so1048728rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2008 02:31:18 -0700 (PDT)
Message-ID: <1ba2fa240805050231j3b975b8bi7d46fa9f7c2701e4@mail.gmail.com> (sfid-20080505_113041_177069_3843B519)
Date: Mon, 5 May 2008 12:31:18 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 20/25] iwlwifi : Set monitor mode for 4965
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Abhijeet Kolekar" <abhijeet.kolekar@intel.com>
In-Reply-To: <1209978354.3655.24.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-18-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-19-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-20-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-21-git-send-email-yi.zhu@intel.com>
	 <1209971503.3655.0.camel@johannes.berg>
	 <1209974740.2827.124.camel@debian.sh.intel.com>
	 <1209976096.3655.19.camel@johannes.berg>
	 <1209977598.2827.134.camel@debian.sh.intel.com>
	 <1209978354.3655.24.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 5, 2008 at 12:05 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  > The thing is the firmware treats it as a different mode. For 4965, we
>  > explicitly setup the "sniffer" type to the firmware so that it operates
>  > differently with other modes. Some drivers (i.e ipw2200) have separated
>  > firmware images for bss, ibss and monitor modes.
>
>  Uh, ok. Weird firmware :)

Yi, we can open pretty much everything even in BSS mode, using
filter_flags in rxon command.

Tomas
