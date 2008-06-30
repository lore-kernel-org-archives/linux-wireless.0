Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:3095 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbYF3ISW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 04:18:22 -0400
Received: by an-out-0708.google.com with SMTP id d40so273951and.103
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2008 01:18:21 -0700 (PDT)
Message-ID: <43e72e890806300118me4b20bv2b91f30f91eaa7f3@mail.gmail.com> (sfid-20080630_101826_613747_BBEA02D4)
Date: Mon, 30 Jun 2008 01:18:21 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tomas Winkler" <tomas.winkler@intel.com>
Subject: Re: [PATCH 1/1 V2] cfg80211: adding NONE regdomain
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	"Ester Kummer" <ester.kummer@intel.com>
In-Reply-To: <1214732604-4573-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1214732604-4573-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 29, 2008 at 2:43 AM, Tomas Winkler <tomas.winkler@intel.com> wrote:
> From: Ester Kummer <ester.kummer@intel.com>
>
> This patch adds an option to enable all the channels by adding a
> value of "NONE" to ieee80211_regdom module param. This is useful
> for NICs that rely on EEPROM regulatory enforcement and for testing

For the EEPROM we should not rely on "none" but on a callback notifier
chain to let the driver do 'the right thing'. I'll post patches
hopefully tonight.

  Luis
