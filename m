Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53217 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318Ab0KJWwa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 17:52:30 -0500
Received: by iwn10 with SMTP id 10so1353111iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 14:52:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimqcK0PEhkW6Y7No8=s4X_HRWOk3tsYPmA5BQ20@mail.gmail.com>
References: <4CDB20D9.603@openwrt.org> <AANLkTimqcK0PEhkW6Y7No8=s4X_HRWOk3tsYPmA5BQ20@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 10 Nov 2010 14:52:10 -0800
Message-ID: <AANLkTinkJq0pGxDcJt=bNtHsHa=Q3YZe_9uweTf6cCMm@mail.gmail.com>
Subject: Re: [PATCH] compat: backport pm_qos_*_request
To: Felix Fietkau <nbd@openwrt.org>,
	Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 10, 2010 at 2:50 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Wed, Nov 10, 2010 at 2:46 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>
> applied with some fuzz, pushed, thanks.

Arnaud, please

git fetch
git rebase origin/master

to ensure you get this too prior to your next submission. No need to
post all the other patches as likely it seems you only need to address
2 patches.

 Luis
