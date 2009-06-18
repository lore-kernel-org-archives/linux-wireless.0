Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:44049 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758822AbZFRWof (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 18:44:35 -0400
Received: by yw-out-2324.google.com with SMTP id 5so774286ywb.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 15:44:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1245353915-30400-2-git-send-email-hauke@hauke-m.de>
References: <1245353915-30400-1-git-send-email-hauke@hauke-m.de>
	<1245353915-30400-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 18 Jun 2009 15:44:17 -0700
Message-ID: <43e72e890906181544n3ccd2a49m84aca01198207d63@mail.gmail.com>
Subject: Re: [PATCH 2/2] [compat-2.6] Update compat.diff
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 18, 2009 at 12:38 PM, Hauke Mehrtens<hauke@hauke-m.de> wrote:
> __dev_addr_sync and __dev_addr_unsync are not exported in older kernels.

Applied and new tarball generated based on this:

v2.6.30-26837-g0ee651a
wireless-testing latest tag:
master-2009-06-17
This is compat-release:
master-2009-06-15-2-ged8e599
