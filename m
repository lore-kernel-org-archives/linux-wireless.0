Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51733 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349Ab0KJXlb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 18:41:31 -0500
Received: by iwn10 with SMTP id 10so1400875iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 15:41:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CDB2998.3070209@openwrt.org>
References: <4CDB2967.7030805@openwrt.org> <4CDB2998.3070209@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 10 Nov 2010 15:41:10 -0800
Message-ID: <AANLkTi=1v8+Wr8EYMCG8xSvHjnY+c=Khwtt0natrSVa4@mail.gmail.com>
Subject: Re: [PATCH 2/2] compat-wireless: remove unnecessary chunks from the
 rfkill patch
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 10, 2010 at 3:24 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

This didn't apply at all, hrm. Can you

git fetch; git rebase origin/master




$ git describe
compat-wireless-2010-11-10-1-gbf23d4b
