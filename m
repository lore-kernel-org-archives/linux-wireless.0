Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47664 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab2AaWsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 17:48:00 -0500
Received: by iacb35 with SMTP id b35so564588iac.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 14:48:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1327618305-23077-1-git-send-email-hauke@hauke-m.de>
References: <1327618305-23077-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 31 Jan 2012 14:47:40 -0800
Message-ID: <CAB=NE6V+Njnf2C+bdCEXVoLVdPAf7FaS08CVjk9R0vu1K5CHsA@mail.gmail.com> (sfid-20120131_234805_546823_5F80981E)
Subject: Re: [PATCH] compat: move br_port_exists() to compat-2.6.36.h
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 26, 2012 at 2:51 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> br_port_exists() was moved to a new compat-*.h file for every new
> kernel release, as it is not in mainline. This patch moves it to compat-
> 2.6.36.h so it has not to be moved any more for a new kernel version.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks! Applied! I'll push shortly after I merge the rest of the
pending patches.

  Luis
