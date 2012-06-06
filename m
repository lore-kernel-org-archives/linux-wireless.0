Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1830 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab2FFLwL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 07:52:11 -0400
Message-ID: <4FCF4459.8020806@broadcom.com> (sfid-20120606_135214_226284_710235B6)
Date: Wed, 6 Jun 2012 13:51:53 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/8] bcma: add constants for chip ids
References: <1338933307-13446-1-git-send-email-hauke@hauke-m.de>
 <1338933307-13446-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1338933307-13446-3-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2012 11:55 PM, Hauke Mehrtens wrote:
> The chip IDs are used all over bcma and no constants where defined.
> This patch adds the constants and makes bcma use them.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/bcma/driver_chipcommon_pmu.c |   81 +++++++++++++++++-----------------
>  drivers/bcma/driver_mips.c           |    8 ++--
>  drivers/bcma/driver_pci_host.c       |    8 ++--
>  drivers/bcma/sprom.c                 |   18 ++++----
>  include/linux/bcma/bcma.h            |   30 +++++++++++++
>  5 files changed, 90 insertions(+), 55 deletions(-)

