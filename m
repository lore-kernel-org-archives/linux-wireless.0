Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.233]:22251 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbXKZRPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 12:15:49 -0500
Received: by nz-out-0506.google.com with SMTP id s18so402932nze
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2007 09:15:48 -0800 (PST)
Message-ID: <1ba2fa240711260915i7f5142f1r300559503db96003@mail.gmail.com> (sfid-20071126_171615_489544_00593A67)
Date: Mon, 26 Nov 2007 19:15:47 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 15/15] iwlwifi: 802.11n add support to 8K A-MSDU Rx frames
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net
In-Reply-To: <1196094375.4149.289.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
	 <11960864922274-git-send-email-ron.rindjunsky@intel.com>
	 <1196094375.4149.289.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 26, 2007 6:26 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > Please notice - in order to work in 8K A-MSDU ucode support is needed,
> > version 4.44.1.19 (soon to be published). 4K A-MSDU works in current ucode
> > version as well.
>
> > +module_param_named(amsdu_size_8K, iwl4965_param_amsdu_size_8K, int, 0444);
> > +MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size");
>
> Can't you read the ucode version instead?
>

8K uCode supports both 4K and 8K A-MSDU. Using 8K is very memory
demanding and we want to leave it configurable for using on embedded
platforms
Tomas

> johannes
>
