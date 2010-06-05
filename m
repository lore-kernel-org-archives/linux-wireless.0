Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:33203 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab0FEHAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jun 2010 03:00:14 -0400
Received: by wwc33 with SMTP id 33so48301wwc.19
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jun 2010 00:00:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1275693948-3189-1-git-send-email-notasas@gmail.com>
References: <1275693948-3189-1-git-send-email-notasas@gmail.com>
Date: Sat, 5 Jun 2010 10:00:12 +0300
Message-ID: <AANLkTin7Pfn0od-m9gQbq992uwC217eVWvmmifCNs-KF@mail.gmail.com>
Subject: Re: [PATCH 1/2] wl1251: fix a memory leak in probe
From: Kalle Valo <kvalo@adurom.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 June 2010 02:25, Grazvydas Ignotas <notasas@gmail.com> wrote:
> wl1251_sdio_probe() error path is missing wl1251_free_hw, add it.

Looks good, thanks.

> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

Acked-by: Kalle Valo <kvalo@adurom.com>
