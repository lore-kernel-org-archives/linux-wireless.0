Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22428 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbbLVRZs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2015 12:25:48 -0500
Date: Tue, 22 Dec 2015 18:25:44 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Geliang Tang <geliangtang@163.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] NFC: trf7970a: use to_spi_device
Message-ID: <20151222172544.GA4383@zurbaran.home> (sfid-20151222_182604_589043_300BDF3D)
References: <a196696aefe502e775a025cdb662c39cbdabf412.1450800897.git.geliangtang@163.com>
 <8847f1817f2c8d91a93b65d87648a4e024b24190.1450800897.git.geliangtang@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8847f1817f2c8d91a93b65d87648a4e024b24190.1450800897.git.geliangtang@163.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tang,

On Wed, Dec 23, 2015 at 12:18:42AM +0800, Geliang Tang wrote:
> Use to_spi_device() instead of open-coding it.
> 
> Signed-off-by: Geliang Tang <geliangtang@163.com>
> ---
>  drivers/nfc/trf7970a.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
Applied and pushed, thanks.

Cheers,
Samuel.

