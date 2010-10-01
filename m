Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46170 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab0JAN4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 09:56:03 -0400
Received: by fxm14 with SMTP id 14so577228fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 06:56:02 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] ar9170: Remove MODULE_FIRMWARE references to two-stage firmware
Date: Fri, 1 Oct 2010 15:55:53 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <1285811096.3916.9.camel@localhost>
In-Reply-To: <1285811096.3916.9.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010011555.54136.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 30 September 2010 03:44:56 Ben Hutchings wrote:
> The combined firmware ar9170.fw is preferred and supports all devices.
> References to the older two-stage firmware are unnecessary.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
you know what? The whole driver could be gone soon too ;-).
