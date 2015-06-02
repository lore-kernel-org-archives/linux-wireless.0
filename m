Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbbFBEzW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 00:55:22 -0400
Date: Tue, 2 Jun 2015 13:55:20 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] staging: wilc1000: Fix some compile time warnings
Message-ID: <20150602045520.GA17524@kroah.com> (sfid-20150602_065543_400241_7F0DEF05)
References: <1433184981-6077-1-git-send-email-kholmanskikh.s.s@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433184981-6077-1-git-send-email-kholmanskikh.s.s@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 01, 2015 at 09:56:18PM +0300, Stanislav Kholmanskikh wrote:
> Signed-off-by: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
> ---
> Changes since V1:
> 
> Split the V1 series into more logically unrelated patches
> and updated patch descriptions accordingly.

This series doesn't apply on my tree due to other changes from someone
else that I just took.  Can you rebase it and resend?

thanks,

greg k-h
