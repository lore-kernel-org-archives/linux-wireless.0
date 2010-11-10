Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60603 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285Ab0KJXEd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 18:04:33 -0500
Received: by iwn10 with SMTP id 10so1362146iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 15:04:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CDB2411.1060502@openwrt.org>
References: <4CDB2411.1060502@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 10 Nov 2010 15:04:13 -0800
Message-ID: <AANLkTi=kiRDpxt761nRjoNL0ZYm31d3oqEoHgSztqiVj@mail.gmail.com>
Subject: Re: [PATCH] compat: backport pm_qos_request
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 10, 2010 at 3:00 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks, I also removed 28-pm-qos-params.patch from compat-wireless now
and pushed both this and the respective compat-wireless patch out.

  Luis
