Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:34735 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbYF3IwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 04:52:20 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1128016waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2008 01:52:20 -0700 (PDT)
Message-ID: <1ba2fa240806300152o6d5f7deby6d00a4421138177c@mail.gmail.com> (sfid-20080630_105226_587554_75EDAAC0)
Date: Mon, 30 Jun 2008 11:52:20 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 1/1 V2] cfg80211: adding NONE regdomain
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	"Ester Kummer" <ester.kummer@intel.com>
In-Reply-To: <43e72e890806300118me4b20bv2b91f30f91eaa7f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214732604-4573-1-git-send-email-tomas.winkler@intel.com>
	 <43e72e890806300118me4b20bv2b91f30f91eaa7f3@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 30, 2008 at 11:18 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Sun, Jun 29, 2008 at 2:43 AM, Tomas Winkler <tomas.winkler@intel.com> wrote:
>> From: Ester Kummer <ester.kummer@intel.com>
>>
>> This patch adds an option to enable all the channels by adding a
>> value of "NONE" to ieee80211_regdom module param. This is useful
>> for NICs that rely on EEPROM regulatory enforcement and for testing
>
> For the EEPROM we should not rely on "none" but on a callback notifier
> chain to let the driver do 'the right thing'. I'll post patches
> hopefully tonight.

Still can be useful for testing,
Tomas
