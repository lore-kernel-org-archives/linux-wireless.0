Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:57057 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbZFMFhe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2009 01:37:34 -0400
MIME-Version: 1.0
Reply-To: maxim@mox.ru
In-Reply-To: <9e4733910906122021k4568df6rd80fb915b64ac12@mail.gmail.com>
References: <1243868091-5315-1-git-send-email-dbaryshkov@gmail.com>
	 <9e4733910906122021k4568df6rd80fb915b64ac12@mail.gmail.com>
Date: Sat, 13 Jun 2009 09:37:34 +0400
Message-ID: <6097c490906122237l2be1836dsd30c3160f1a15ae8@mail.gmail.com>
Subject: Re: [RFC][WIP] IEEE 802.15.4 implementation for Linux v1
From: Maxim Osipov <maxim.osipov@gmail.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, slapin@ossfans.org,
	maxim.osipov@siemens.com, dmitry.baryshkov@siemens.com,
	oliver.fendt@siemens.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 13, 2009 at 7:21 AM, Jon Smirl<jonsmirl@gmail.com> wrote:
> On Mon, Jun 1, 2009 at 10:54 AM, Dmitry
> Eremin-Solenikov<dbaryshkov@gmail.com> wrote:
>> Hi,
>>
>> As a part of research activities the Embedded Systems - Open Platform Group
>> from Siemens Corporate Technology we are working on adding support for
>> the IEEE 802.15.4 Wireless Personal Area Networks to the Linux. Our current
>> implementation is neither certified nor even feature complete. However
>> we'd like to present current state of our patchset to the Linux developers
>> community to gain comments, fixes, ideas, etc. This is not yet a pull request,
>> but more like an RFC.
>>
>
> The Zigbee alliance requires a minimum of $3,500/yr from any company
> making a product based on the spec. How are you going to reconcile
> this requirement with the GPL? They exempt non-commercial users but
> the GPL doesn't allow code to be free for one purpose and pay for
> another.
>

For now, we do not release any ZigBee implementation. BTW - could you
refer to particular clause of GPL, which doesn't allow user to pay for
code?

Regards,
Maxim
