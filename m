Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40718 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab0CASHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 13:07:46 -0500
Received: by pwj8 with SMTP id 8so1805223pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 10:07:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1267465615.2253.159.camel@rchatre-DESK>
References: <201002281534.11656.helmut.schaa@googlemail.com>
	<1267465615.2253.159.camel@rchatre-DESK>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 1 Mar 2010 10:07:25 -0800
Message-ID: <43e72e891003011007p6053aaaewef3a0d639159c120@mail.gmail.com>
Subject: Re: iwl4965: 11a channels disabled in current wireless-testing
To: reinette chatre <reinette.chatre@intel.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 1, 2010 at 9:46 AM, reinette chatre
<reinette.chatre@intel.com> wrote:
> On Sun, 2010-02-28 at 06:34 -0800, Helmut Schaa wrote:
>> have there been any recent changes to the regulatory stuff, especially
>> in conjunction with iwlagn?
>>
>> Because with wireless-testing I get all 11a channels disabled by default
>> and the same for channels 12 & 13 in the g-band.
>
> This could be related to a change in the default regulatory domain. It
> used to be US, but now it is world,

This change actually happened a while ago and the world regulatory
domain actually enables passive scanning on a lot of channels instead
of straight out disabling them.

> which is more restrictive. You can
> modify your regulatory domain using "iw reg set <domain>"

For Intel, as well as with Atheros cards, cards using 'iw reg set'
would actually not yield enabling new channels, it would only disable
channels further.

  Luis
