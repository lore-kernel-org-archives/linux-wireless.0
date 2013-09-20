Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:65142 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761Ab3ITPb3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 11:31:29 -0400
Date: Fri, 20 Sep 2013 17:31:24 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-nfc@lists.01.org, linux-wireless@vger.kernel.org,
	lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org
Subject: Re: [PATCH 2/2] NFC: pn533: Staticize local symbols
Message-ID: <20130920153124.GE26066@zurbaran> (sfid-20130920_173132_043785_0BED1FB9)
References: <1379667641-31149-1-git-send-email-sachin.kamat@linaro.org>
 <1379667641-31149-2-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1379667641-31149-2-git-send-email-sachin.kamat@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sachin,

On Fri, Sep 20, 2013 at 02:30:41PM +0530, Sachin Kamat wrote:
> Local symbols used only in this file are made static.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/nfc/pn533.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
Applied as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
