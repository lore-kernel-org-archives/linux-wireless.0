Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:49378 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbYH1Lco (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 07:32:44 -0400
Received: by ey-out-2122.google.com with SMTP id 6so99186eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2008 04:32:42 -0700 (PDT)
Message-ID: <1ba2fa240808280432w2c4360b4mc173a2bab75a94ce@mail.gmail.com> (sfid-20080828_133248_968166_91CB63A1)
Date: Thu, 28 Aug 2008 14:32:42 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: [PATCH 02/11] iwlwifi: use mac80211 band and channel settings
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1219926478.6064.9.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219926478.6064.9.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2008 at 3:27 PM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Yi,
>
>> This patch makes use of mac80211 defaults for channel and band settings
>> instead of setting them by the driver own. The iwlwifi driver used to
>> set G band channel 6 as the default channel.
>
> that is not a regression. The driver has been doing this until now and
> thus it can keep doing it until the next merge window.
>
> If you disagree, then please explain the regression in the commit
> message.

It's trashing initial configuration as two different configuration
were applied in the initial flow. Frankly I don't remember what bug we
had this with. Maybe it's not so urgent.
Tomas
