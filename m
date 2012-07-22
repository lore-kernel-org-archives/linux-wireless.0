Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51724 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2GVIch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jul 2012 04:32:37 -0400
Message-ID: <500BBAA0.5050304@qca.qualcomm.com> (sfid-20120722_103319_957673_BE27067E)
Date: Sun, 22 Jul 2012 11:32:32 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] ath6kl: add support for changing contry code
References: <20120719125937.22047.91375.stgit@x201> <20120719130056.22047.19196.stgit@x201> <CAB=NE6UTDeYowTXdZ-2uGzQgQ3MWxwg-xpYYXxbpT-J6iacjcg@mail.gmail.com>
In-Reply-To: <CAB=NE6UTDeYowTXdZ-2uGzQgQ3MWxwg-xpYYXxbpT-J6iacjcg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/19/2012 10:54 PM, Luis R. Rodriguez wrote:
> On Thu, Jul 19, 2012 at 6:00 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> To make it possible to change the country code from user space via nl80211
>> add handler for reg_notifier. The feature is only enabled when built
>> time option CONFIG_ATH6KL_REGDOMAIN is enabled, which again depends on
>> CFG80211_CERTIFICATION_ONUS for certication purposes.
>>
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> 
> Ah OK so a followup patch would use ath6kl_wmi_set_regdomain_cmd() ?

The current code already does that. The followup patch would change
ath6kl so that it follows the cellular BTS hints and advertises the
support for that.

Kalle
