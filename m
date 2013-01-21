Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab3AUKmO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2013 05:42:14 -0500
Date: Mon, 21 Jan 2013 11:41:54 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, ilw@linux.intel.com,
	ldv-project@linuxtesting.org
Subject: Re: [PATCH] iwlegacy: don't return zero on failure paths in
 il4965_pci_probe()
Message-ID: <20130121104153.GA5424@redhat.com> (sfid-20130121_114232_362098_D9E7EB16)
References: <1358600194-20371-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1358600194-20371-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 19, 2013 at 04:56:34PM +0400, Alexey Khoroshilov wrote:
> If hardware is not ready, il4965_pci_probe() breaks off initialization,
> deallocates all resources, but returns zero.
> The patch adds -EIO as return value in this case.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

ACK

